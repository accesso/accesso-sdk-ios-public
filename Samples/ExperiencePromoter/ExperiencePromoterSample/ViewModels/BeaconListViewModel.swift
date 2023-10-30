//
//  BeaconListViewModel.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 4/26/23.
//

import Foundation
import AccessoExperiencePromoter

@MainActor
class BeaconListViewModel: ObservableObject {
    @Published var isListening = false
    @Published var beacons: [String: BeaconRegion] = [:]
    
    private var beaconRegions: [BeaconRegion] = []
    private var experiencePromoterModule: ExperiencePromoterProviding

    init(with experiencePromoterModule: ExperiencePromoterProviding = ExperiencePromoterProvider.shared) {
        self.experiencePromoterModule = experiencePromoterModule
    }

    /// Get all beacon regions
    func getBeaconRegions() async {
        print("Called getBeaconRegions")
        do {
            self.beaconRegions = try await experiencePromoterModule.getBeaconRegions()
            self.updateListeningStatus()

            // Convert to dictionary
            beaconRegions.forEach({ beaconRegion in
                self.beacons[beaconRegion.id] = beaconRegion
            })
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        // Update the beacon region with latest beacon status
        experiencePromoterModule.beaconDetection = { [weak self] beaconRegion in
            self?.beacons[beaconRegion.id] = beaconRegion
        }
    }
    
    /// Start monitoring for beacon regions
    func listenForBeacons() {
        experiencePromoterModule.startListeningForBeaconRegions(beaconRegions: beaconRegions)
        updateListeningStatus()
    }
    
    /// Stop monitoring for beacon regions
    func stopListeningBeacons() {
        experiencePromoterModule.stopListeningForBeaconRegions(beaconRegions: nil)
        updateListeningStatus()
    }
    
    // MARK: - Private
    
    /// Update the beacon listener status
    private func updateListeningStatus() {
        isListening = experiencePromoterModule.beaconListenerStatus == .listening
    }
}
