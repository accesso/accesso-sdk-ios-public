//
//  LoginView.swift
//  QueueingSample
//
//  Created by James Layton on 3/13/24.
//

import SwiftUI
import AccessoCore

struct LoginView: View {
    @StateObject private var authVM = AuthenticationViewModel()

    @State private var alertDetails: AlertDetails?
    @State private var showAlert = false

    @State private var showQueueingHomeView = false

    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("Sign In")
                    .font(.title)

                CustomTextField(title: "Email", placeholder: "email", inputValue: $username)

                CustomTextField(title: "Password", placeholder: "password", inputValue: $password)

                CustomActionButton(title: "Sign in") {
                    Task {
                        do {
                            try await authVM.fetchAccessToken(username: username, password: password)
                            showQueueingHomeView.toggle()
                        } catch {
                            showAlert(message: error.localizedDescription)
                        }
                    }
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showQueueingHomeView) {
            if let coreToken = authVM.coreToken {
                QueueingHomeView(coreToken: coreToken)
            }
        }
        .alert(with: $showAlert, alertDetails: $alertDetails)
    }

    func showAlert(message: String) {
        showAlert = true
        alertDetails = AlertDetails(title: "", message: message)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
