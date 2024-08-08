//
//  NoRowView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 7/3/23.
//

import SwiftUI

/// A view for empty list
struct NoRowView: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("No \(text.lowercased())")
                Text("(Pull to refresh)")
            }
            Spacer()
        }
    }
}

struct NoRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoRowView(text: "points of interest")
    }
}
