//
//  CustomButton.swift
//  QueueingSample
//
//  Created by Vy Le on 10/2/23.
//

import SwiftUI

struct CustomButton: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(Color(uiColor: .systemBackground))
            .frame(width: 200, height: 20)
            .padding()
            .background(Color("ButtonBackground"))
            .cornerRadius(10)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "View Attractions")
    }
}
