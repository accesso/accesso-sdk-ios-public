//
//  CustomButton.swift
//  QueueingSample
//
//  Created by Vy Le on 10/2/23.
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
        .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
        .background(Color(.black))
        .cornerRadius(5)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "View Attractions") {
            // Do nothing
        }

    }
}
