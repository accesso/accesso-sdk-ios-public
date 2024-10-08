//
//  POIDetailView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 7/3/23.
//
// swiftlint:disable line_length

import SwiftUI
import AccessoCore
import AccessoExperiencePromoter

struct POIDetailView: View {
    /// The Point of Interest (POI) for which detailed information is displayed.
    private var poi: PointOfInterest
    
    /// Initializes a `POIDetailView` with a given Point of Interest.
    /// - Parameter pointOfInterest: The Point of Interest to display in detail.
    init(pointOfInterest: PointOfInterest) {
        self.poi = pointOfInterest
    }
    
    var body: some View {
        AsyncImageView(
            imageURL: poi.images?.first?.src,
            size: CGSize(width: 200, height: 200),
            contentMode: .fit,
            showSpinner: false,
            disableImageSize: true
        )
        .frame(minWidth: 200, minHeight: 200)
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(poi.description ?? "")
                    .font(.body)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(16)
            Spacer()
        }
        .navigationTitle(poi.label)
    }
}

struct POIDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedPOI = PointOfInterest(id: "poiId1", label: "J6", description: "High speed quad with access to a number of exceptional trails.", status: nil, images: [PoiImage(resolution: Resolution.mdpi, src: "https://stage-img.te2.io/unsafe/0x130:4840x3326/alterra/ALT_JUN/client/51353f73-80bb-4468-a1f5-5c764ed72f7b/17-18_JUNE_0137.jpg")], details: [], tags: [], location: Location(lat: 37.76137943997584, lon: -119.0821460198261), sticker: nil, layoutType: nil, beacons: nil, type: "")
        return POIDetailView(pointOfInterest: mockedPOI)
    }
}
// swiftlint:enable line_length
