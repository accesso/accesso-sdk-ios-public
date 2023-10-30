//
//  CustomTextField.swift
//  EntitlementsSample
//
//  Created by James Layton on 8/29/23.
//

import SwiftUI

struct CustomTextField: View {

    var title: String
    var placeholder: String
    @Binding var inputValue: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontWeight(.bold)

            VStack {
                ZStack(alignment: .leading) {
                    if inputValue.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .padding(.leading)
                    }
                    TextField(placeholder, text: $inputValue)
                        .foregroundColor(.black)
                        .frame(height: 20)
                        .padding()
                }
            }
            .background(Color("TextBackground"))
            .cornerRadius(5)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(title: "Barcode", placeholder: "Enter Barcode here", inputValue: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
