//
//  HomeView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 4/24/23.
//

import SwiftUI
import AccessoExperiencePromoter

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 60) {
                // Navigation link to the Message Inbox section.
                NavigationLink("Message Inbox") {
                    MessageListView()
                }

                // Navigation link to the Beacons section.
                NavigationLink("Beacons") {
                    BeaconListView()
                }
                
                // Navigation link to the Points of Interest section.
                NavigationLink("Points Of Interest") {
                    POIListView()
                }

                NavigationLink("Events") {
                    EventListView()
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
