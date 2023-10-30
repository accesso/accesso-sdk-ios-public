//
//  View+HideKeyboard.swift
//  EntitlementsSample
//
//  Created by James Layton on 8/29/23.
//

import SwiftUI

extension View {
    func forEachWithIndex<Data: RandomAccessCollection, Content: View>(_ data: Data,
                                                                       @ViewBuilder content: @escaping (Data.Index, Data.Element) -> Content) -> some View where Data.Element: Identifiable, Data.Element: Hashable {
        ForEach(Array(zip(data.indices, data)), id: \.1) { index, element in
            content(index, element)
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
