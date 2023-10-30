//
//  BeaconListView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 4/24/23.
//

import SwiftUI

struct BeaconListView: View {
    @StateObject private var beaconListViewModel = BeaconListViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Status: \(beaconListViewModel.isListening ? "Listening" : "Stopped")")
           
            List {
                Section {
                    ForEach(Array(beaconListViewModel.beacons.values), id: \.id) { beaconRegion in
                        HStack {
                            Circle()
                                .fill(beaconRegion.beaconStatus == .ENTER ? .green : .red)
                                .frame(width: 10, height: 10)
                                .padding(.trailing, 4)
                            Text("UUID: \(beaconRegion.proximityUUID), Major: \(beaconRegion.major ?? 0)")
                                .listRowSeparatorTint(.gray)
                        }
                    }
                } header: {
                    Text("Beacon Regions")
                }
            }
            .navigationTitle("Beacons")
            .listStyle(.grouped)
            .listRowSeparatorTint(.gray)
            .onAppear {
                Task {
                    await beaconListViewModel.getBeaconRegions()
                }
            }
            
            Button {
                if !beaconListViewModel.isListening {
                    beaconListViewModel.listenForBeacons()
                } else {
                    beaconListViewModel.stopListeningBeacons()
                }
            } label: {
                Text("\(beaconListViewModel.isListening ? "Stop" : "Start") Listening")
            }
        }
    }
}

struct BeaconListView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconListView()
    }
}
