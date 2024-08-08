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
    /// A shared instance of the `MessageListViewModel`.
    public static let sharedIntance = MessageListViewModel()

    /// The application instance.
    private let application = UIApplication.shared

    /// The Experience Promoter module.
    private var experiencePromoterModule: ExperiencePromoterProviding = ExperiencePromoterProvider.shared
    
    /// A **boolean** to reflect the need of showing an alert for new messages
    @Published public var showAlertForNewMessage = false
    /// A **boolean** to reflect the current state of loading messages
    @Published public var isRefreshing = false
    /// A local array to hold the **Messages** to display
    @Published public var messages: [Message] = []
    
    /// A boolean indicating whether the user has granted permission for the app to send notifications
    @Published public var isNotificationPermissionGranted = false
    
    /// The message from a push notification.
    private(set) var pushNotificationMessage = ""

    /// The result of data fetching operations.
    enum DataFetchResult {
        case success(newDataAvailable: Bool)
        case failure
    }

    /// Initializes the `MessageListViewModel` with a given module.
    ///
    /// - Parameter module: The Experience Promoter module to use.
    convenience init(with module: ExperiencePromoterProviding) {
        self.init()
        experiencePromoterModule = module
    }

    /// Calls the module to get the Messages from server and stores it into a local var that is published
    public func getMessages() async {
        print("Called getMessages")
        // Sets the `isRefreshing` flag to indicate that a fetch operation is in progress.
        self.isRefreshing = true

        do {
            // Fetch messages from the server and updates the view model's `messages` property with the retrieved data.
            self.messages = try await experiencePromoterModule.getMessages(venueId: nil)
            self.isRefreshing = false
        } catch {
            // Log and handle the error in case of a fetch failure.
            print(error)
        }
    }
    
    /// Mark message as read
    ///
    /// - Parameters:
    ///   - messageId: The message Id associate with the message
    ///
    /// - Important: This function uses UserDefaults to quickly store the read status of the message.
    /// For more complex applications, it is recommended to use Core Data for efficient and scalable data management.
    func markRead(message: Message) {
        // Check if the message is not already marked as read and find its index
        if !message.isRead, let index = messages.firstIndex(where: { $0.id == message.id }) {
            // Mark the message as read in the view model.
            messages[index].isRead = true

            // Store the read status in UserDefaults.
            UserDefaults.standard.set(true, forKey: message.id)
        }
    }
    
    /// Reload all messages and update the permission status
    func reload() async {
        // Refresh the list of messages.
        await getMessages()

        // Update the notification permission status.
        _ = await checkPermissionStatus()
    }
    
    // MARK: - Notifications
    /// Requests the user’s authorization to allow local and remote notifications
    func requestNotificationPermission() async {
        do {
            // Request user authorization for notifications with specific options.
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                // Permission granted, update the flag and log the success.
                print("Push notification permission granted.")
                self.isNotificationPermissionGranted = true
            } else {
                // Permission denied, update the flag and log the denial.
                print("Push notification permission denied.")
                self.isNotificationPermissionGranted = false
            }
        } catch {
            // Log and handle the error in case of a permission request failure.
            print("Push notification permission denied with error: \(error.localizedDescription)")
        }

        // Register for remote notifications (push notifications).
        application.registerForRemoteNotifications()
    }
    
    /// Gets the current notification permission status and sends the response to the module.
    ///
    /// - Returns: The current authorization status for notifications.
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        // Ensure that the configuration is available from CoreProvider.
        guard let config = CoreProvider.shared.configuration else {
            return .notDetermined
        }

        // Create a notification state event with relevant information to send to the server.
        var notificationStateEvent = AppNotificationStateEvent(id: "123",
                                                               appUserId: config.appUserId,
                                                               appId: config.appId,
                                                               state: .disabled,
                                                               eventType: .notificationState)

        // Get the current notification settings from the user notification center.
        let settings = await UNUserNotificationCenter.current().notificationSettings()

        // Check the authorization status and update the view model's permission state accordingly.
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            self.isNotificationPermissionGranted = true
            notificationStateEvent.state = .enabled
        default:
            self.isNotificationPermissionGranted = false
            notificationStateEvent.state = .disabled
        }

        // Send the notification state event to the server.
        await self.trackAppNotificationState(appNotificationStateEvent: notificationStateEvent)
        return settings.authorizationStatus
    }
    
    /// Calls for getMessages when a push notification comes in
    /// - Parameters:
    ///   - userInfo: array of user info related to the handled push notification
    ///   - action: The action associate with the message such as received and read
    func handleNotification(_ userInfo: [AnyHashable: Any], action: MessageAction? = nil) async -> DataFetchResult {
        // Extract the notification payload information.
        guard let aps = userInfo["aps"] as? [String: AnyObject],
              let notificationMessage = aps["alert"] as? String else {
            // If the payload doesn't contain the expected information, return a success result with no new data.
            return DataFetchResult.success(newDataAvailable: false)
        }
        
        // Update the push notification message and trigger an alert to show the new message.
        pushNotificationMessage = notificationMessage
        showAlertForNewMessage = true

        // Refresh the message list to reflect the new message.
        await getMessages()
        
        // Send a tracking event to the server with the specified action.
        guard let messageId = userInfo["i"] as? String else {
            // If the message ID is not available, return a success result with new data.
            return DataFetchResult.success(newDataAvailable: true)
        }
        
        // Create a message event for tracking.
        let event = MessageEvent(appId: "PTOWN_PT", messageId: messageId, action: action)
        let actionDescription = event.action.debugDescription

        do {
            // Send the tracking event and log the result.
            try await experiencePromoterModule.trackMessageAction(messageEvent: event)
            print("Successfully send track message for \(actionDescription)")
            return DataFetchResult.success(newDataAvailable: true)
        } catch {
            // Log and handle any errors that occur during tracking.
            print("Failed to send track message for \(actionDescription): \(error)")
            return DataFetchResult.failure
        }
    }
    
    /// Handle new push token in application. Upload to platform etc.
    ///
    /// - Parameter token: String with push token or empty string
    func updateDeviceToken(token: Data) -> String? {
        // Convert the device token data to a string.
        let token = getPushTokenFrom(deviceTokenData: token)

        // Create log parameters for event tracking.
        let logParameters = LogParameters(subsystem: Log.Subsystem.hostApp,
                                          category: Log.Category.startup)
        // Log the updated device token.
        Log.logEvent("Push Token: '\(token)'", parameters: logParameters)

        // Update the device token locally.
        experiencePromoterModule.pushDeviceToken = token
       
        // Return the updated device token.
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
        // Convert the device token data to a string by formatting each byte to a 2-character hexadecimal representation.
        let token = deviceTokenData.map { String(format: "%02.2hhx", $0) }.joined()
        // Create log parameters for event tracking.
        let logParameters = LogParameters(subsystem: Log.Subsystem.hostApp,
                                          category: Log.Category.startup)
        // Log the device token for debugging and tracking purposes.
        Log.logEvent("Push Token: \(token)", parameters: logParameters)

        // Return the device token as a string.
        return token
    }
    
    /// Send a platform tracker message event for notification register
    ///
    /// - Parameter state: The state of the notification (Enabled / Disabled)
    private func trackAppNotificationState(appNotificationStateEvent: AppNotificationStateEvent) async {
        do {
            // Attempt to send the notification state event to the server.
            try await experiencePromoterModule.trackAppNotificationState(
                appNotificationStateEvent: appNotificationStateEvent
            )

            // Log a success message with the notification state.
            print("Successfully send push notification permission response for \(appNotificationStateEvent.state.rawValue)")
        } catch {
            // Handle and log any errors that occur during the event tracking.
            print("Failed to send push notification permission response: \(error)")
        }
    }
    
    /// Navigate to system settings
    func navigateToSettings() async {
        // Check if the settings URL is valid and can be opened.
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
            await UIApplication.shared.open(appSettings as URL, options: [:])
        }
    }

    // MARK: - Firebase
    /// Helper method to handle the registration token generated by Firebase Cloud Messaging (FCM).
    /// - Parameters:
    ///   - messaging: The Firebase Messaging instance
    ///   - fcmToken: An optional String holding the generated token
    nonisolated func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Log the generated FCM registration token for debugging and tracking.
        print("Firebase registration token: \(String(describing: fcmToken))")

        // Create a dictionary to hold the token for broadcasting.
        let dataDict: [String: String] = ["token": fcmToken ?? ""]

        // Broadcast the FCM token using NotificationCenter.
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // Note: You can send the FCM token to an application server if necessary.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
