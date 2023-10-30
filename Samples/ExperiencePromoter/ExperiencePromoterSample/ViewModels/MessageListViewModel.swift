//
//  MessageListViewModel.swift
//  ExperiencePromoterSample
//
//  Created by Mark McCorkle on 1/22/23.
//

import AccessoExperiencePromoter
import AccessoCore
import Firebase
import UIKit

/// Custom class to handle the main logic of this integration example.
///
/// - Configures and starts the Experience Promoter module
/// - Fetchs and store Messages
/// - Handles push notifications

@MainActor
class MessageListViewModel: NSObject, MessagingDelegate, ObservableObject {
    public static let sharedIntance = MessageListViewModel()
    private let application = UIApplication.shared
    private var experiencePromoterModule: ExperiencePromoterProviding = ExperiencePromoterProvider.shared
    
    /// A **boolean** to reflect the need of showing an alert for new messages
    @Published public var showAlertForNewMessage = false
    /// A **boolean** to reflect the current state of loading messages
    @Published public var isRefreshing = false
    /// A local array to hold the **Messages** to display
    @Published public var messages: [Message] = []
    
    ///A boolean indicating whether the user has granted permission for the app to send notifications
    @Published public var isNotificationPermissionGranted = false
    
    private(set) var pushNotificationMessage = ""

    enum DataFetchResult {
        case success(newDataAvailable: Bool)
        case failure
    }

    convenience init(with module: ExperiencePromoterProviding) {
        self.init()
        experiencePromoterModule = module
    }

    /// Calls the module to get the Messages from server and stores it into a local var that is published
    public func getMessages() async {
        print("Called getMessages")
        self.isRefreshing = true
        do {
            self.messages = try await experiencePromoterModule.getMessages(venueId: nil)
            self.isRefreshing = false
        } catch {
            print (error)
        }
    }
    
    /// Mark message as read
    ///
    /// - Parameters:
    ///   - messageId: The message Id associate with the message
    ///
    ///- Important: This function uses UserDefaults to quickly store the read status of the message.
    /// For more complex applications, it is recommended to use Core Data for efficient and scalable data management.
    func markRead(message: Message) {
        if !message.isRead, let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages[index].isRead = true
            UserDefaults.standard.set(true, forKey: message.id)
        }
    }
    
    /// Reload all messages and update the permission status
    func reload() async {
        await getMessages()
        _ = await checkPermissionStatus()
    }
    
    // MARK: - Notifications
    /// Requests the user’s authorization to allow local and remote notifications
    func requestNotificationPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                print("Push notification permission granted.")
                self.isNotificationPermissionGranted = true
            } else {
                print("Push notification permission denied.")
                self.isNotificationPermissionGranted = false
            }
        } catch {
            print("Push notification permission denied with error: \(error.localizedDescription)")
        }

        application.registerForRemoteNotifications()
    }
    
    /// Get the current notification permission and send the response to module
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        guard let config = CoreProvider.shared.configuration else {
            return .notDetermined
        }

        var notificationStateEvent = AppNotificationStateEvent(id: "123", appUserId: config.appUserID, appId: config.appID ?? "PTOWN_PT", state: .disabled, eventType: .notificationState)
        let settings = await UNUserNotificationCenter.current().notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            self.isNotificationPermissionGranted = true
            notificationStateEvent.state = .enabled
        default:
            self.isNotificationPermissionGranted = false
            notificationStateEvent.state = .disabled
        }

        await self.trackAppNotificationState(appNotificationStateEvent: notificationStateEvent)
        return settings.authorizationStatus
    }
    
    /// Calls for getMessages when a push notification comes in
    /// - Parameters:
    ///   - userInfo: array of user info related to the handled push notification
    ///   - action: The action associate with the message such as received and read
    func handleNotification(_ userInfo: [AnyHashable : Any], action: MessageAction? = nil) async -> DataFetchResult {
        guard let aps = userInfo["aps"] as? [String: AnyObject],
              let notificationMessage = aps["alert"] as? String else {
            return DataFetchResult.success(newDataAvailable: false)
        }
        
        pushNotificationMessage = notificationMessage
        showAlertForNewMessage = true
        await getMessages()
        
        // Send track message response with action
        guard let messageId = userInfo["i"] as? String else {
            return DataFetchResult.success(newDataAvailable: true)
        }
        
        let event = MessageEvent(appId: "PTOWN_PT", messageId: messageId, action: action)
        let actionDescription = event.action.debugDescription
        do {
            try await experiencePromoterModule.trackMessageAction(messageEvent: event)
            print("Successfully send track message for \(actionDescription)")
            return DataFetchResult.success(newDataAvailable: true)
        } catch {
            print("Failed to send track message for \(actionDescription): \(error)")
            return DataFetchResult.failure
        }
    }
    
    /// Handle new push token in application. Upload to platform etc.
    ///
    /// - Parameter token: String with push token or empty string
    func updateDeviceToken(token: Data) -> String? {
        let token = getPushTokenFrom(deviceTokenData: token)
        let logParameters = LogParameters(subsystem: Log.Subsystem.hostApp,
                                          category: Log.Category.startup)
        Log.logEvent("Push Token: '\(token)'", parameters: logParameters)

        // API Update Token Here...
        experiencePromoterModule.pushDeviceToken = token
       
        return token
    }
    
    // MARK: - Helpers
    
    /// Helper to get this installation token in order to use it on targeted message from Control Room
    fileprivate func getRegistrationToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
    
    /// Get a push token string from data
    ///
    /// - Parameter deviceTokenData: data containing push token
    /// - Returns: push token string
    private func getPushTokenFrom(deviceTokenData: Data) -> String {
        let token = deviceTokenData.map{ String(format: "%02.2hhx", $0) }.joined()
        let logParameters = LogParameters(subsystem: Log.Subsystem.hostApp,
                                          category: Log.Category.startup)
        Log.logEvent("Push Token: \(token)", parameters: logParameters)
        return token
    }
    
    /// Send a platform tracker message event for notification register
    ///
    /// - Parameter state: The state of the notification (Enabled / Disabled)
    private func trackAppNotificationState(appNotificationStateEvent: AppNotificationStateEvent) async {
        do {
            try await experiencePromoterModule.trackAppNotificationState(appNotificationStateEvent: appNotificationStateEvent)
            print("Successfully send push notification permission response for \(appNotificationStateEvent.state.rawValue)")
        } catch {
            print("Failed to send push notification permission response: \(error)")
        }        
    }
    
    /// Navigate to system settings
    func navigateToSettings() async {
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
            await UIApplication.shared.open(appSettings as URL, options: [:])
        }
    }

    // MARK: - Firebase
    
    /// Firebase Helper to check the token generation
    /// - Parameters:
    ///   - messaging: a Firebase Messaging instance
    ///   - fcmToken: optional String holding the generated token
    nonisolated func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // Note: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
