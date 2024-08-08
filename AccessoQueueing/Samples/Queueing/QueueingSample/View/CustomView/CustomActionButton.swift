//
//  CustomActionButton.swift
//  QueueingSample
//
//  Created by James Layton on 3/13/24.
//

import SwiftUI

struct CustomActionButton: View {
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

struct CustomActionButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomActionButton(title: "Get Attraction") {
            // Do nothing
        }
    }
}
