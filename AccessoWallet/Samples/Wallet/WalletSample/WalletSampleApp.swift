//
//  WalletSampleApp.swift
//  WalletSample
//
//  Created by Dave Becker on 11/16/23.
//

import SwiftUI
import AccessoCore

@main
struct WalletSampleApp: App {
    init() {
        CoreProvider.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
