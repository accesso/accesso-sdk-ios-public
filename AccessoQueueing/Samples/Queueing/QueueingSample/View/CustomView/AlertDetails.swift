//
//  AlertDetails.swift
//  QueueingSample
//
//  Created by James Layton on 10/9/23.
//

import SwiftUI

enum ButtonRole {
    case cancel
    case destructive
    case normal
}

struct AlertDetails: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let buttons: [Button]

    init(title: String, message: String, buttons: [Button] = []) {
        id = UUID()
        self.title = title
        self.message = message
        self.buttons = !buttons.isEmpty ? buttons : [Button(title: "Ok", role: .cancel) {
            // Do nothing
        }]
    }

    struct Button {
        let title: String
        let role: ButtonRole
        let action: () -> Void
    }
}
