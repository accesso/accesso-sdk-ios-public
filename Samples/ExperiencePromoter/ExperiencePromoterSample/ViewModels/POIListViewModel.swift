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
    @Published var pointsOfInterest: [PointOfInterest] = []
    private var experiencePromoterModule: ExperiencePromoterProviding = ExperiencePromoterProvider.shared

    convenience init(module: ExperiencePromoterProviding) {
        self.init()
        self.experiencePromoterModule = module
    }

    /// Get all beacon regions
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
