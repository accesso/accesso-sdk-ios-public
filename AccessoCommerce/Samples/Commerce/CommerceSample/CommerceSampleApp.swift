//
//  CommerceSampleApp.swift
//  CommerceSample
//
//  Created by Vy Le on 1/10/24.
//

import SwiftUI
import AccessoCore
import AccessoCommerce

@main
struct CommerceSampleApp: App {
    init() {
        CoreProvider.configure()
        CoreProvider.shared.configureThemeCustomization()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ProductShopView()
            }
        }
    }
}
