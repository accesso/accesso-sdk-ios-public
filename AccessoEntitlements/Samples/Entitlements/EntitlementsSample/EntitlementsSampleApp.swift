//
//  EntitlementsSampleApp.swift
//  EntitlementsSample
//
//  Created by James Layton on 8/30/23.
//

import SwiftUI
import AccessoCore

@main
struct EntitlementsSampleApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        CoreProvider.configure()
    }

    var body: some Scene {
        WindowGroup {
            EntitlementsHome()
                .onOpenURL { url in
                    print("Open the url: \(url)")
                }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("App Active")
            case.background:
                print("App in background")
            case .inactive:
                print("App inactive")
            @unknown default:
                fatalError("Fatal error")
            }
        }
    }
}
