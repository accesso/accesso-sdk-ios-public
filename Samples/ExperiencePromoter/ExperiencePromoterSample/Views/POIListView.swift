//
//  POIListView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 7/3/23.
//

import Foundation
import SwiftUI
import AccessoExperiencePromoter

struct POIListView: View {
    @StateObject var viewModel = POIListViewModel()
    
    var body: some View {
        VStack {
            List {
                if viewModel.pointsOfInterest.count == 0 {
                    NoRowView(text: "points of interest")
                } else {
                    ForEach(viewModel.pointsOfInterest, id: \.id) { poi in
                        NavigationLink {
                            POIDetailView(pointOfInterest: poi)
                        } label: {
                            POIRowView(pointOfInterest: poi)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .listRowSeparatorTint(.gray)
            .onAppear {
                Task {
                    await viewModel.getPointsOfInterest()
                }
            }
            .refreshable {
                await viewModel.getPointsOfInterest()
            }
        }
        .navigationTitle("Points Of Interest")
    }
}

struct POIListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedPOI = PointOfInterest(id: "poiId1", label: "J6", description: "High speed quad with access to a number of exceptional trails.", status: nil, images: [Image(resolution: Resolution.mdpi, src: "https://stage-img.te2.io/unsafe/0x130:4840x3326/alterra/ALT_JUN/client/51353f73-80bb-4468-a1f5-5c764ed72f7b/17-18_JUNE_0137.jpg")], details: [], tags: [], location: Location(lat: 37.76137943997584, lon: -119.0821460198261), sticker: nil, layoutType: nil, beacons: nil, type: "")
        let viewModel = POIListViewModel()
        viewModel.pointsOfInterest = [mockedPOI]
        let view = POIListView(viewModel: viewModel)
        return view
    }
}
