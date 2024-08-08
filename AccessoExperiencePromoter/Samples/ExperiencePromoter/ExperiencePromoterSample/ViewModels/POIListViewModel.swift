//
//  POIListViewModel.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 7/3/23.
//

import Foundation
import AccessoExperiencePromoter

@MainActor
class POIListViewModel: ObservableObject {
    /// An array containing the Points of Interest (POI) to be displayed.
    @Published var pointsOfInterest: [PointOfInterest] = []

    /// The instance of `ExperiencePromoterProviding` used for fetching POIs.
    private var experiencePromoterModule: ExperiencePromoterProviding = ExperiencePromoterProvider.shared

    /// Convenience initializer to set the `experiencePromoterModule`.
    ///
    /// - Parameters:
    ///   - module: An instance of `ExperiencePromoterProviding` to use for fetching POIs.
    convenience init(module: ExperiencePromoterProviding) {
        self.init()
        self.experiencePromoterModule = module
    }

    /// Retrieves all points of interest
    func getPointsOfInterest() async {
        print("Called getPointsOfInterest")
        do {
            self.pointsOfInterest = try await experiencePromoterModule.getPointsOfInterest()
            print("Received pointsOfInterest: \(pointsOfInterest)")
        } catch {
            print(error)
        }
    }
}
