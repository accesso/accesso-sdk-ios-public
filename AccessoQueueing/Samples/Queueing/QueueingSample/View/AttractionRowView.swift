//
//  AttractionRowView.swift
//  QueueingSample
//
//  Created by Vy Le on 10/3/23.
//

import SwiftUI
import AccessoCore
import AccessoQueueing

struct AttractionRowView: View {
    var attraction: Attraction
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImageView(
                imageURL: attraction.thumbnailImage.absoluteString,
                cornerRadius: 30,
                size: CGSize(width: 60, height: 60),
                showSpinner: false
            )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(attraction.name)
                    .font(.headline)
                    .truncationMode(.tail)
                Text(attraction.description)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AttractionRowView_Previews: PreviewProvider {
    static var previews: some View {
        AttractionRowView(attraction: MockQueueingData.attractions()[0])
    }
}
