//
//  EntitlementsHome.swift
//  EntitlementsSample
//
//  Created by James Layton on 8/28/23.
//

import SwiftUI

struct EntitlementsHome: View {

    @StateObject private var entitlementsVM = EntitlementsViewModel()
    @State private var barcode = ""
    @State private var orderId = ""
    @State private var emailAddress = ""

    @State private var alertDetails: AlertDetails?
    @State private var showAlert: Bool = false
    @State private var isTaskLoading = false

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 16) {
                    CustomButton(title: "Get Entitlement") {
                        getButtonTapped()
                    }
                    .padding(.bottom)

                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    CustomTextField(title: "Barcode", placeholder: "Enter your Barcode Number", inputValue: $barcode)

                    Text("Or")
                        .font(.headline)

                    CustomTextField(title: "Order ID", placeholder: "Enter your Order ID", inputValue: $orderId)

                    Text("And")
                        .font(.headline)

                    CustomTextField(title: "Email Address", placeholder: "Enter your Email Address", inputValue: $emailAddress)

                    CustomButton(title: "Claim Entitlement") {
                        claimButtonTapped()
                    }
                    .padding(.top)
                }
                .navigationTitle("Entitlements")
                .navigationBarTitleDisplayMode(.inline)
                .padding(32)
            }

            CustomProgress(isVisible: isTaskLoading)
        }
        .alert(with: $showAlert, alertDetails: $alertDetails)
        .onTapGesture {
            hideKeyboard()
        }
    }

    func getButtonTapped() {
        Task {
            isTaskLoading = true
            do {
                let entitlementNames = try await entitlementsVM.getEntitlement()
                showAlert(message: "\(entitlementNames)")
            } catch {
                showAlert(message: error.localizedDescription)
            }
            isTaskLoading = false
        }
    }

    func claimButtonTapped() {
        Task {
            isTaskLoading = true
            do {
                let status = try await entitlementsVM.claimEntitlement(barcode: barcode, orderId: orderId, email: emailAddress)
                showAlert(message: status)
            } catch {
                showAlert(message: error.localizedDescription)
            }
            isTaskLoading = false
        }
    }

    func showAlert(message: String) {
        showAlert = true
        alertDetails = AlertDetails(title: "", message: message)
    }
}

struct EntitlementsHome_Previews: PreviewProvider {
    static var previews: some View {
        EntitlementsHome()
    }
}
