//
//  QueueingSampleApp.swift
//  QueueingSample
//
//  Created by Vy Le on 10/2/23.
//

import SwiftUI
import AccessoCore

@main
struct QueueingSampleApp: App {
    @StateObject private var appUIManager = AppUIManager()

    init() {
        CoreProvider.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(appUIManager)
        }
    }
}
