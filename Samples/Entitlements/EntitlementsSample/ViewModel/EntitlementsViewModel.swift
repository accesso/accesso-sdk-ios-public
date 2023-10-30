//
//  EntitlementsViewModel.swift
//  EntitlementsSample
//
//  Created by James Layton on 8/29/23.
//

import Foundation
import AccessoCore
import AccessoEntitlements

@MainActor
class EntitlementsViewModel: ObservableObject {

    private let entitlementsProvider: EntitlementsProviding
    
    init() {
        let isUiTesting = CommandLine.arguments.contains("--ui-testing")
        
        // Use mock implementation if we're running UI tests
        if(isUiTesting) {
            entitlementsProvider = MockEntitlements()
        } else {
            entitlementsProvider = EntitlementsProvider.shared
        }
    }
    
    func getEntitlement() async throws -> [String] {
        let entitlements = try await entitlementsProvider.getEntitlements()
        return entitlements.map { $0.displayName }
    }

    func claimEntitlement(barcode: String?, orderId: String?, email: String?) async throws -> String {

        var claimType: ClaimEntitlementType = .barcode(code: "")

        if let barcode, !barcode.isEmpty {
            claimType = .barcode(code: barcode)
        } else if let orderId, !orderId.isEmpty, let email, !email.isEmpty {
            claimType = .orderId(id: orderId, orderEmail: email)
        } else {
            throw NSError(domain: "com.Sample", code: 999,
                          userInfo: [NSLocalizedDescriptionKey: "Missing values: enter barcode or orderId and email"])
        }

        let result = try await entitlementsProvider.claimEntitlement(registrationType: claimType)

        switch result {
        case .claimed(status: _):
            return "Claim successful"
        case .claimedButProcessing(status: _):
            return "Claim processing"
        case .notFound:
            return "Not found"
        }
    }
}
