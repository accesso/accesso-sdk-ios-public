//
//  MockQueueingProvider.swift
//  QueueingSample
//
//  Created by Agustin Rodriguez-Cabada on 10/18/23.
//

import Foundation
import AccessoQueueing

class MockQueueingProvider: QueueingProviding {
    func getAttractions() async throws -> [Attraction] {
        return MockQueueingData.attractions()
    }
    
    func getAttraction(with attractionId: String) async throws -> Attraction? {
        return MockQueueingData.attraction()
    }

    func reserveAction(with reservation: ReservationAction) async throws {
        if reservation.id != "TestCorrectID" {
            let error = NSError(domain: "TestDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Wrong reservation ID."])
            throw error
        }
    }
}
