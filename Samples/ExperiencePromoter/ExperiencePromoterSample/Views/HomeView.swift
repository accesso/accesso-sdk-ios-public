//
//  HomeView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 4/24/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 60) {
                NavigationLink("Message Inbox") {
                    MessageListView()
                }
                NavigationLink("Beacons") {
                    BeaconListView()
                }
                NavigationLink("Points Of Interest") {
                    POIListView()
                }
            }
            .navigationTitle("Experience Promoter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
