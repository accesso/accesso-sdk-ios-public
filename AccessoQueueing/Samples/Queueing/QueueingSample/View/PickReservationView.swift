//
//  PickReservationView.swift
//  QueueingSample
//
//  Created by James Layton on 10/18/23.
//

import SwiftUI
import AccessoQueueing

struct PickReservationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var attractionVM: AttractionViewModel
    let reserveAction: Attraction.ReserveAction

    @EnvironmentObject private var appUIManager: AppUIManager
    @State private var inputNumbers: [String: Int] = [:]

    init(attractionVM: AttractionViewModel, reserveAction: Attraction.ReserveAction) {
        self.attractionVM = attractionVM
        self.reserveAction = reserveAction
        self._inputNumbers = State(
            initialValue: Dictionary(uniqueKeysWithValues: reserveAction.inputRequirements.map {
                ($0.id, $0.defaultValue)
            })
        )
    }

    var body: some View {
        VStack {
            ScrollView {
                ForEach(reserveAction.inputRequirements) { inputRequirement in
                    let currentValue = inputNumbers[inputRequirement.id] ?? 0
                    let canIncrement = currentValue < inputRequirement.maximum
                    let canDecrement = currentValue > inputRequirement.minimum

                    HStack(spacing: 16) {
                        Text(inputRequirement.title)

                        Spacer()

                        Button {
                            self.decrement(for: inputRequirement.id, inputRequirement: inputRequirement)
                        } label: {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .scaledToFit()
                                .foregroundStyle(Color(uiColor: .label))
                                .accessibilityIdentifier("attraction_decrease_\(inputRequirement.title)")
                        }
                        .disabled(!canDecrement)
                        .opacity(!canDecrement ? 0.5 : 1)

                        Text("\(inputNumbers[inputRequirement.id] ?? 0)")
                            .font(.title2)
                            .frame(width: 25)
                            .accessibilityIdentifier("attraction_\(inputRequirement.title)_value")

                        Button {
                            self.increment(for: inputRequirement.id, inputRequirement: inputRequirement)
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .scaledToFit()
                                .foregroundStyle(Color(uiColor: .label))
                                .accessibilityIdentifier("attraction_increase_\(inputRequirement.title)")
                        }
                        .disabled(!canIncrement)
                        .opacity(!canIncrement ? 0.5 : 1)
                    }
                }
            }

            confirmationButton
        }
    }

    private var confirmationButton: some View {
        Button {
            Task {
                appUIManager.isTaskLoading = true
                do {
                    try await attractionVM.makeReservation(reservationId: reserveAction.id, inputNumbers: inputNumbers)
                    self.showAlert("Reserved successfully") {
                        self.dismiss()
                    }
                } catch {
                    showAlert(error.localizedDescription)
                }
                appUIManager.isTaskLoading = false
            }
        } label: {
            CustomButton(title: "Confirm Reservation")
        }
        .accessibilityIdentifier("attraction_confirm_reservation_button")
    }

    func showAlert(_ message: String) {
        appUIManager.showAlert = true
        appUIManager.alertDetails = AlertDetails(title: "", message: message)
    }

    func showAlert(_ message: String, action: @escaping () -> Void) {
        appUIManager.showAlert = true
        let button = AlertDetails.Button(title: "OK", role: .cancel, action: action)
        appUIManager.alertDetails = AlertDetails(title: "", message: message, buttons: [button])
    }
}

// Group related functions
extension PickReservationView {
    private func increment(for inputRequirementID: String, inputRequirement: Attraction.ReserveAction.InputRequirement) {
        guard let currentValue = inputNumbers[inputRequirementID] else { return }
        if currentValue < inputRequirement.maximum {
            inputNumbers[inputRequirementID] = currentValue + 1
        }
    }

    private func decrement(for inputRequirementID: String, inputRequirement: Attraction.ReserveAction.InputRequirement) {
        guard let currentValue = inputNumbers[inputRequirementID], currentValue > 0 else { return }
        if currentValue > inputRequirement.minimum {
            inputNumbers[inputRequirementID] = currentValue - 1
        }
    }
}

// swiftlint:disable force_unwrapping
struct PickReservationView_Previews: PreviewProvider {
    static var previews: some View {
        PickReservationView(attractionVM: AttractionViewModel(),
                            reserveAction: AttractionViewModel().reserveAction!)
    }
}
// swiftlint:enable force_unwrapping
