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
    /// A published property indicating whether beacon detection is currently active.
    @Published var isListening = false

    /// A dictionary that stores beacon regions with their corresponding `BeaconRegion` objects.
    @Published var beacons: [String: BeaconRegion] = [:]
    
    /// An array of `BeaconRegion` objects representing the beacon regions to monitor.
    private var beaconRegions: [BeaconRegion] = []

    /// The provider for the Experience Promoter module.
    private var experiencePromoterModule: ExperiencePromoterProviding

    /// Initializes the view model with an optional `ExperiencePromoterProviding` instance.
    ///
    /// - Parameter experiencePromoterModule: An optional `ExperiencePromoterProviding` instance, which defaults to the shared `ExperiencePromoterProvider`.
    init(with experiencePromoterModule: ExperiencePromoterProviding = ExperiencePromoterProvider.shared) {
        self.experiencePromoterModule = experiencePromoterModule
    }

    /// Retrieves all beacon regions and updates the view model.
    func getBeaconRegions() async {
        print("Called getBeaconRegions")
        do {
            // Retrieve the beacon regions from the Experience Promoter module.
            self.beaconRegions = try await experiencePromoterModule.getBeaconRegions()

            // Update the listening status based on the retrieved beacon regions.
            self.updateListeningStatus()

            // Convert the beacon regions to a dictionary for easy access.
            beaconRegions.forEach { beaconRegion in
                self.beacons[beaconRegion.id] = beaconRegion
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        // Update the beacon region status when detection events occur.
        experiencePromoterModule.beaconDetection = { [weak self] beaconRegion in
            self?.beacons[beaconRegion.id] = beaconRegion
        }
    }
    
    /// Start monitoring for beacon regions
    func listenForBeacons() {
        // Start monitoring for the specified beacon regions.
        experiencePromoterModule.startListeningForBeaconRegions(beaconRegions: beaconRegions)

        // Update the listening status based on the current state.
        updateListeningStatus()
    }
    
    /// Stop monitoring for beacon regions
    func stopListeningBeacons() {
        // Stop monitoring for all beacon regions.
        experiencePromoterModule.stopListeningForBeaconRegions(beaconRegions: nil)

        // Update the listening status based on the current state.
        updateListeningStatus()
    }
    
    // MARK: - Private
    /// Update the beacon listener status
    private func updateListeningStatus() {
        // Update the `isListening` property based on the beacon listener's status.
        isListening = experiencePromoterModule.beaconListenerStatus == .listening
    }
}
