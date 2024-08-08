//
//  EntitlementsHome.swift
//  EntitlementsSample
//
//  Created by James Layton on 8/28/23.
//

import SwiftUI
import AccessoCore
import AccessoWallet
import AccessoEntitlements

/// Use Claim Entitlement button to claim an entitlement and the use get Entitlement to show a list of the Entitlements claimed
struct EntitlementsHome: View {
    @StateObject private var entitlementsVM = EntitlementsViewModel()
    @State private var barcode = ""
    @State private var orderId = ""
    @State private var emailAddress = ""

    @State private var alertDetails: AlertDetails?
    @State private var showAlert = false
    @State private var isTaskLoading = false

    @State private var showBarcodeScanner = false
    @State private var shouldStopScanner = false

    @State private var pass: WalletPass?

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 16) {
                    CustomButton(title: "Get Entitlement") {
                        getButtonTapped()
                    }

                    if let pass {
                        AccessoWallet.AddToWalletButton(pass: pass)
                            .frame(width: 240, height: 60)
                    }

                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding([.horizontal, .top])

                    /// Barcode Scanner functionality using our ``CustomTextField``
                    CustomTextField(title: "Barcode", placeholder: "Enter your Barcode Number", inputValue: $barcode, showBarcode: true) {
                        Task {
                            if await CoreProvider.shared.cameraManager.isAuthorizedForVideo(forceRequest: true) {
                                showBarcodeScanner = true
                                shouldStopScanner = false
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showBarcodeScanner) {
                        BarcodeScanner(result: $barcode, shouldStopSession: $shouldStopScanner)
                            .ignoresSafeArea()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name.receivedBarcode)) { _ in
                        shouldStopScanner = true
                        claimButtonTapped()
                    }

                    Text("Or")
                        .font(.headline)

                    CustomTextField(title: "Order ID", placeholder: "Enter your Order ID", inputValue: $orderId)

                    Text("And")
                        .font(.headline)

                    CustomTextField(title: "Email Address",
                                    placeholder: "Enter your Email Address",
                                    inputValue: $emailAddress)

                    CustomButton(title: "Claim Entitlement") {
                        claimButtonTapped()
                    }
                    .padding(.top)
                }
                .navigationTitle("Entitlements")
                .navigationBarTitleDisplayMode(.inline)
                .padding(16)
            }

            CustomProgress(isVisible: isTaskLoading)
        }
        .alert(with: $showAlert, alertDetails: $alertDetails)
    }

    /// Obtains the current list of entitlements and presents an alert showing them
    func getButtonTapped() {
        Task {
            isTaskLoading = true
            do {
                let entitlementNames = try await entitlementsVM.getEntitlement()
                showAlert(message: "\(entitlementNames)")
                let entitlements = try await EntitlementsProvider.shared.getEntitlements()
                if !entitlements.isEmpty {
                    var walletPass = entitlements[0].createWalletPass()
                    // Customize pass as desired. Example:
                    walletPass.walletData.voided = false
                    self.pass = walletPass
                }
            } catch {
                showAlert(message: error.localizedDescription)
            }
            isTaskLoading = false
        }
    }

    /// Claims an entitlement with either combination of barcode or OrderId and Email
    func claimButtonTapped() {
        Task {
            isTaskLoading = true
            do {
                let status = try await entitlementsVM.claimEntitlement(barcode: barcode,
                                                                       orderId: orderId,
                                                                       email: emailAddress)
                showAlert(message: status)
            } catch {
                showAlert(message: error.localizedDescription)
            }
            
            barcode = ""
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
