//
//  View+AlertView.swift
//  QueueingSample
//
//  Created by James Layton on 10/9/23.
//

import SwiftUI

struct AlertView: ViewModifier {

    @Binding var showAlert: Bool
    @Binding var alertDetails: AlertDetails?

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .alert(Text(alertDetails?.title ?? ""), isPresented: $showAlert, presenting: alertDetails) { detail in
                    makeAlertButtons(buttons: detail.buttons)
                } message: { detail in
                    Text("\(detail.message)")
                }
        } else {
            content
                .alert(isPresented: $showAlert) {
                    makeAlert()
                }
        }
    }

    private func makeAlert() -> Alert {
        guard let alertDetails = alertDetails else {
            return Alert(title: Text(""))
        }

        let alertButtons = alertDetails.buttons.map { button in
            Alert.Button.default(Text(button.title), action: button.action)
        }

        if let firstButton = alertButtons.first {
            if alertButtons.count == 1 {
                return Alert(title: Text(alertDetails.title),
                             message: Text(alertDetails.message),
                             dismissButton: firstButton)
            } else {
                return Alert(title: Text(alertDetails.title),
                             message: Text(alertDetails.message),
                             primaryButton: firstButton,
                             secondaryButton: alertButtons[1])
            }
        } else {
            return Alert(title: Text(alertDetails.title),
                         message: Text(alertDetails.message))
        }
    }

    private func makeAlertButtons(buttons: [AlertDetails.Button]) -> some View {
        ForEach(buttons, id: \.title) { button in
            Button("\(button.title)") {
                button.action()
            }
        }
    }
}

extension View {
    func alert(with showAlert: Binding<Bool>, alertDetails: Binding<AlertDetails?>) -> some View {
        modifier(AlertView(showAlert: showAlert, alertDetails: alertDetails))
    }
}
