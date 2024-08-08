//
//  AttractionViewModel.swift
//  QueueingSample
//
//  Created by Vy Le on 10/3/23.
//

import Foundation
import AccessoCore
import AccessoQueueing

enum AttractionFetchResult: String {
    case noData = "Server return empty data"
}

/// Issues with @Observable and @MainActor conflict
/// https://forums.swift.org/t/observable-macro-conflicting-with-mainactor/67309
@MainActor
class AttractionViewModel: ObservableObject {
    /// A object to hold **Attraction** to display
    @Published var attraction: Attraction?

    /// A local array to hold the **Attractions** to display
    @Published var attractions = [Attraction]()

    @Published var reserveAction: Attraction.ReserveAction?

    private var accessoQueueingProvider: QueueingProviding = QueueingProvider.shared

    init() {
        // Use mock implementation if we're running UI tests
        let isUiTesting = CommandLine.arguments.contains("--ui-testing")
        accessoQueueingProvider = isUiTesting ? MockQueueingProvider() : QueueingProvider.shared
    }
    
    convenience init(with module: QueueingProviding) {
        self.init()
        
        // Use mock implementation if we're running UI tests
        let isUiTesting = CommandLine.arguments.contains("--ui-testing")
        accessoQueueingProvider = isUiTesting ? MockQueueingProvider() : module
    }

    func getAttraction(With attractionID: String) async throws {
        if let fetchedAttraction = try await accessoQueueingProvider.getAttraction(with: attractionID) {
            attraction = fetchedAttraction
        } else {
            let error = NSError(domain: "ErrorDomain",
                                code: 999,
                                userInfo: [NSLocalizedDescriptionKey: AttractionFetchResult.noData.rawValue])
            throw error
        }
    }

    func getAttractions() async throws {
        let fetchedAttractions = try await accessoQueueingProvider.getAttractions()
        if fetchedAttractions.isEmpty {
            let error = NSError(domain: Constant.InvalidState.errorDomain,
                                code: Constant.InvalidState.errorCode,
                                userInfo: [NSLocalizedDescriptionKey: AttractionFetchResult.noData.rawValue])
            throw error
        } else {
            attractions = fetchedAttractions
        }
    }

    func makeReservation(reservationId: String, inputNumbers: [String: Int]) async throws {
        guard let row = inputNumbers["seat_row"], let seat = inputNumbers["seat_num"] else {
            let error = NSError(domain: Constant.InvalidState.errorDomain,
                                code: Constant.InvalidState.errorCode,
                                userInfo: [NSLocalizedDescriptionKey: "Please pick a row and a seat."])
            throw error
        }

        let reservationData = ReservationActionData(seatRow: row, seatNum: seat)
        let resevationAction = ReservationAction(id: reservationId, data: reservationData)
        try await accessoQueueingProvider.reserveAction(with: resevationAction)
    }

    func prettyPrintAttractionToJSON(_ attraction: Attraction) -> String {
        if let encodedAttraction = try? JSONEncoder().encode(attraction),
           let json = try? JSONSerialization.jsonObject(with: encodedAttraction, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self)
        } else {
            return "N/A"
        }
    }
}
