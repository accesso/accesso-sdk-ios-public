//
//  MockEntitlements.swift
//  EntitlementsSample
//
//  Created by Agustin Rodriguez-Cabada on 9/19/23.
//

import Foundation
import AccessoEntitlements

internal class MockEntitlements: EntitlementsProviding {
    // MARK: Mocked functions
    func claimEntitlement(registrationType: ClaimEntitlementType) async throws -> ClaimEntitlementResult {
        let isNegativeTesting = CommandLine.arguments.contains("--negative-testing")
        
        if !isNegativeTesting {
            let status = try JSONDecoder().decode(ClaimEntitlementStatus.self,
                                                  from: MockEntitlements.successfulClaimData)
            return ClaimEntitlementResult.claimed(status: status)
        } else {
            return ClaimEntitlementResult.notFound
        }
    }
    
    func getEntitlements() async throws -> [Entitlement] {
        return try JSONDecoder().decode([Entitlement].self, from: MockEntitlements.entitlementData)
    }
    
    // MARK: Mock response data
    // Set within tests
    private static var successfulClaimData = Data("""
        {
            "processingMode": "PROCESSING_ORDER",
            "success": true
        }
    """.utf8)
    
    private static var entitlementData = Data("""
        [
            {
                "id": "entitlement-1",
                "entitlementType": "Entitlement",
                "description": "Sample Entitlement 1",
                "displayClassId": "abcde12345",
                "displayName": "Display Name 1",
                "status": "active",
                "systemOfRecordId": "record-1",
                "displayClass": {}
            }
        ]

    """.utf8)
}
