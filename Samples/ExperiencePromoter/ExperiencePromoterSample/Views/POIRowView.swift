//
//  POIRowView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 7/3/23.
//

import SwiftUI
import AccessoExperiencePromoter

struct POIRowView: View {
    private var poi: PointOfInterest
    
    init(pointOfInterest: PointOfInterest) {
        self.poi = pointOfInterest
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                if let url = URL(string: poi.images?.first?.src ?? "") {
                    AsyncImage(
                        url: url,
                        content: { image in
                            image.circleImageModifier()
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                    .frame(width: 60, height: 60)
                } else {
                    Image("placeholderImage")
                        .circleImageModifier()
                }
                
                VStack(alignment: .leading) {
                    Text(poi.label)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .padding(.bottom, 2)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(poi.description ?? "")
                        .font(.system(size: 14))
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
                .padding(.leading, 4)
            }
        }
    }
}

struct POIRowView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedPOI = PointOfInterest(id: "poiId1", label: "J6", description: "High speed quad with access to a number of exceptional trails.", status: nil, images: [Image(resolution: Resolution.mdpi, src: "https://stage-img.te2.io/unsafe/0x130:4840x3326/alterra/ALT_JUN/client/51353f73-80bb-4468-a1f5-5c764ed72f7b/17-18_JUNE_0137.jpg")], details: [], tags: [], location: Location(lat: 37.76137943997584, lon: -119.0821460198261), sticker: nil, layoutType: nil, beacons: nil, type: "")
        POIRowView(pointOfInterest: mockedPOI)
    }
}
