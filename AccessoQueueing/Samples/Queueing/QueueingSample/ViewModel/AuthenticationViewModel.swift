//
//  AuthenticationViewModel.swift
//  QueueingSample
//
//  Created by James Layton on 3/13/24.
//

import Foundation
import AccessoCore

class AuthenticationViewModel: ObservableObject {
    @Published var coreToken: CoreToken?

    @MainActor
    func fetchAccessToken(username: String, password: String) async throws {
        coreToken = try await CoreProvider.shared.identity.getAccessToken(username: username, password: password)
    }
}
