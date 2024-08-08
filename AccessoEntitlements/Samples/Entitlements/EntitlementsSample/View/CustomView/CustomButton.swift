//
//  CustomButton.swift
//  EntitlementsSample
//
//  Created by James Layton on 8/29/23.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: (() -> Void)

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(uiColor: .systemBackground))
        }
        .padding()
        .background(Color("ButtonBackground"))
        .cornerRadius(5)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Get Entitlements") {
            // Do nothing
        }
    }
}
