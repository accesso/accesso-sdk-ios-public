//
//  AttractionDetailView.swift
//  QueueingSample
//
//  Created by Vy Le on 10/3/23.
//

import SwiftUI
import AccessoQueueing

struct AttractionDetailView: View {
    @ObservedObject var attractionVM: AttractionViewModel
    let attractionId: String

    @EnvironmentObject private var appUIManager: AppUIManager
    @State var showPickSeatView = false

    var body: some View {
        VStack {
            if let attraction = attractionVM.attraction {
                AsyncImage(
                    url: attraction.thumbnailImage,
                    content: { image in
                        image
                            .resizable()
                            .scaledToFill()
                    },
                    placeholder: {
                        Image("placeholderImage")
                            .resizable()
                            .scaledToFill()
                    }
                ).accessibilityIdentifier("attraction_details_image")

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(attraction.name.capitalized)
                            .font(.title)
                            .truncationMode(.tail)
                            .accessibilityIdentifier("attraction_details_name")
                        Spacer()
                        Text(attraction.state.capitalized)
                            .font(.footnote)
                            .accessibilityIdentifier("attraction_details_status")
                    }

                    Group {
                        Text("Queueing")
                            .font(.footnote)
                        Text("Virtual - \(Int(attraction.waitTimeInMinutes)) min")
                            .font(.headline)
                            .accessibilityIdentifier("attraction_details_wait_time")
                    }

                    if showPickSeatView {
                        if let reserveAction = attractionVM.reserveAction {
                            PickReservationView(attractionVM: attractionVM,
                                                reserveAction: reserveAction)
                        } else {
                            Text("No reserve action available")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    } else {
                        Group {
                            Text("JSON Response")
                                .font(.subheadline)
                            ScrollView(showsIndicators: false) {
                                Text(attractionVM.prettyPrintAttractionToJSON(attraction))
                                    .padding()
                                    .accessibilityIdentifier("attraction_details_json")
                            }
                            .refreshable {
                                Task {
                                    await loadAttraction()
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(uiColor: .label), lineWidth: 1)
                            )

                            ReservationButtonsView(attractionVM: attractionVM,
                                                   attraction: attraction,
                                                   showPickSeatView: $showPickSeatView)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle(attractionVM.attraction?.name ?? "")
        .task {
            await loadAttraction()
        }
    }

    func loadAttraction() async {
        appUIManager.isTaskLoading = true
        do {
            try await attractionVM.getAttraction(With: attractionId)
        } catch {
            showAlert(error.localizedDescription)
        }
        appUIManager.isTaskLoading = false
    }

    func showAlert(_ message: String) {
        appUIManager.showAlert = true
        appUIManager.alertDetails = AlertDetails(title: "", message: message)
    }
}

struct AttractionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AttractionDetailView(attractionVM: AttractionViewModel(), attractionId: "AttractionID")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

