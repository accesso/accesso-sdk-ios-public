//
//  ExperiencePromoterSampleApp.swift
//  ExperiencePromoterSample
//
//  Created by Mark McCorkle on 1/13/23.
//

import SwiftUI
import Firebase
import AccessoCore
import AccessoExperiencePromoter

@main
struct ExperiencePromoterSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // This will create an accesso config from the Accesso-Info.plist file and configure all the required functions for the module
        let config = Configuration.config()

        // Start the SDK
        CoreProvider.configure(using: config)

        // Request location permission
        ExperiencePromoterProvider.shared.promptForLocationPermission()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private let messagesListViewModel = MessageListViewModel.sharedIntance
    private let logParameters = LogParameters(subsystem: Log.Subsystem.hostApp,
                                                  category: Log.Category.startup)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Main App fired up.")
        
        UNUserNotificationCenter.current().delegate = self
        Task {
            await messagesListViewModel.requestNotificationPermission()
        }

        if let _ = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist") {
            FirebaseApp.configure()
            print("FirebaseApp configured")
        } else {
            print("Please add your Firebase configuration!")
        }

        Messaging.messaging().delegate = messagesListViewModel

        return true
    }
}

// MARK: - Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        // Send the deviceToken data to the Experience Promoter module for push notification tracking
        let tokenString = messagesListViewModel.updateDeviceToken(token: deviceToken)

        Log.logEvent("didRegisterForRemoteNotificationsWithDeviceToken: \(tokenString ?? "No token")", parameters: logParameters)
        Task {
            _ = await messagesListViewModel.checkPermissionStatus()
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Log.logEvent("didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)", parameters: logParameters)
        Task {
            _ = await messagesListViewModel.checkPermissionStatus()
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        Log.logEvent("didReceiveRemoteNotification: \(userInfo.debugDescription)",
                     parameters: logParameters)

        let result = await messagesListViewModel.handleNotification(userInfo)
        switch result {
        case .success(let newDataAvailable):
            return newDataAvailable ? .newData : .noData
        case .failure:
            return .failed
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        Log.logEvent("didReceive response: \(response.debugDescription)",
                     parameters: logParameters)
        _ = await messagesListViewModel.handleNotification(response.notification.request.content.userInfo, action: .pushWhileNotOpen)
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        Log.logEvent("willPresent notification: \(notification.debugDescription)",
                     parameters: logParameters)

        _ = await messagesListViewModel.handleNotification(notification.request.content.userInfo, action: .pushWhileOpen)
        return [[.banner, .badge, .sound]]
    }
}
