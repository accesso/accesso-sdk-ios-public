//
//  MessageListView.swift
//  Views
//
//  Created by Vy Le on 1/25/23.
//
// swiftlint:disable line_length

import SwiftUI
import AccessoCore
import AccessoExperiencePromoter

/// This is a main view that shows the list of messages
///
/// - Tap on message will take user to a detailed view
/// - User will be able to refresh by pulling down to refresh
/// - The circle dot to indicate READ and UNREAD messages
struct MessageListView: View {
    /// The view model that manages message data.
    @StateObject var messageListViewModel = MessageListViewModel.sharedIntance

    /// A flag indicating whether to show the notification permission prompt.
    @State var showPermissionPrompt = false
    
    var body: some View {
        VStack {
            if !messageListViewModel.isNotificationPermissionGranted {
                Button {
                    showPermissionPrompt = true
                } label: {
                    Text("Enable Notifications")
                }
            }
            
            List {
                if messageListViewModel.messages.isEmpty {
                    NoRowView(text: "Message")
                } else {
                    ForEach(messageListViewModel.messages, id: \.id) { message in
                        NavigationLink {
                            MessageDetailView(messageListViewModel: messageListViewModel, message: message)
                        } label: {
                            MessageRowView(message: message)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .listRowSeparatorTint(.gray)
            .onAppear {
                Task {
                    await messageListViewModel.reload()
                }
            }
            .refreshable {
                await messageListViewModel.reload()
            }
            .alert("Enable Notification", isPresented: $showPermissionPrompt, actions: {
                Button("Go to settings") {
                    Task {
                        await messageListViewModel.navigateToSettings()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("To receive messages, please enable notifications for this app by going to Settings > Notifications > Allow Notifications")
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task {
                    await messageListViewModel.reload()
                }
            }
        }
        .navigationTitle("Message Inbox")
    }
}

struct MessageListView_Previews: PreviewProvider {
    static let mockedMessage = Message(id: "123", subject: "new message", body: "The MessageDetailView now displays the message body and other properties in a VStack with increased vertical padding. The subject now uses a larger font size and is displayed in bold to make it stand out. The Date label is set as a headline for better readability.", isRead: true, images: [MessageImage(width: 480, height: 460, src: "https://www.accesso.com/imager/images/markets/market-theme-park/6681/Theme-Parks-Header-XXL_ac21bf3414a21ce27b0a0c85a113c91a.jpg")])
    static let mockedUnreadMessage = Message(id: "1234", subject: "really really long long long subject", isRead: false)
    
    static var previews: some View {
        let view = MessageListView()
        view.messageListViewModel.messages = []
        view.messageListViewModel.messages.append(mockedMessage)
        view.messageListViewModel.messages.append(mockedMessage)
        view.messageListViewModel.messages.append(mockedMessage)
        view.messageListViewModel.messages.append(mockedUnreadMessage)
        return view
    }
}
// swiftlint:enable line_length
