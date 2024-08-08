//
//  CustomTextField.swift
//  QueueingSample
//
//  Created by James Layton on 3/13/24.
//

import SwiftUI

/// Custom TextField  that displays a button to present the scanner to read barcodes from the camera.
struct CustomTextField: View {
    var title: String
    var placeholder: String
    @Binding var inputValue: String
    /// Show / Hide the Barcode Scanner button
    var showBarcode: Bool = false
    /// Delegate call after reading a barcode from the camera feed
    var barcodeAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontWeight(.bold)

            VStack {
                HStack {
                    ZStack(alignment: .leading) {
                        if inputValue.isEmpty {
                            Text(placeholder)
                                .foregroundColor(.gray)
                                .frame(height: 20)
                                .padding(.leading)
                        }
                        TextField(placeholder, text: $inputValue)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .foregroundColor(.black)
                            .frame(height: 20)
                            .padding()
                    }

                    if showBarcode, let barcodeAction {
                        Button(action: barcodeAction) {
                            Image(systemName: "barcode.viewfinder")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .scaledToFit()
                                .foregroundColor(.black)
                        }
                        .padding()
                        .cornerRadius(5)
                    }
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
