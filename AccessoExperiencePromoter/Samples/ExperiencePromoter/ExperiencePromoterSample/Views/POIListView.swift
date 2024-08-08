//
//  POIListView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 7/3/23.
//
// swiftlint:disable line_length

import Foundation
import SwiftUI
import AccessoExperiencePromoter

struct POIListView: View {
    /// The state object representing the view model for managing POI data.
    @StateObject var viewModel = POIListViewModel()
    
    var body: some View {
        VStack {
            List {
                if viewModel.pointsOfInterest.isEmpty {
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
                // Automatically fetch POI data when the view appears.
                Task {
                    await viewModel.getPointsOfInterest()
                }
            }
            .refreshable {
                // Manually refresh the POI data when the user triggers the refresh action.
                await viewModel.getPointsOfInterest()
            }
        }
        .navigationTitle("Points Of Interest")
    }
}

struct POIListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedPOI = PointOfInterest(id: "poiId1", label: "J6", description: "High speed quad with access to a number of exceptional trails.", status: nil, images: [PoiImage(resolution: Resolution.mdpi, src: "https://stage-img.te2.io/unsafe/0x130:4840x3326/alterra/ALT_JUN/client/51353f73-80bb-4468-a1f5-5c764ed72f7b/17-18_JUNE_0137.jpg")], details: [], tags: [], location: Location(lat: 37.76137943997584, lon: -119.0821460198261), sticker: nil, layoutType: nil, beacons: nil, type: "")
        let viewModel = POIListViewModel()
        viewModel.pointsOfInterest = [mockedPOI]
        let view = POIListView(viewModel: viewModel)
        return view
    }
}

// swiftlint:enable line_length
