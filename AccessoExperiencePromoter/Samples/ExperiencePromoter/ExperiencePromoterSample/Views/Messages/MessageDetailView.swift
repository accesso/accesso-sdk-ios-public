//
//  MessageDetailView.swift
//  Views
//
//  Created by Vy Le on 1/25/23.
//
// swiftlint:disable line_length

import SwiftUI
import AccessoCore
import AccessoExperiencePromoter

/// A view to show the message information
struct MessageDetailView: View {
    /// The view model that manages message data.
    @ObservedObject var messageListViewModel: MessageListViewModel

    /// The message to display details for.
    var message: Message

    /// A date formatter for formatting the message's publish time.
    private let dateFormatter = DateFormatter()

    /// The formatted date string for the message's publish time.
    private var formattedDate: String {
        return dateFormatter.string(from: message.publishTime ?? Date())
    }

    /// Initializes the view with the message list view model and a message.
    init(messageListViewModel: MessageListViewModel, message: Message) {
        self.messageListViewModel = messageListViewModel
        self.message = message
        self.dateFormatter.dateStyle = .long
    }

    var body: some View {
        AsyncImageView(
            imageURL: message.images?.first?.src,
            size: CGSize(width: 200, height: 200),
            contentMode: .fit,
            showSpinner: false,
            disableImageSize: true
        )
        .frame(minWidth: 200, minHeight: 200)
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(message.body ?? "No Body")
                    .font(.body)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(16)
            Spacer()
        }
        .navigationTitle(message.subject ?? "No Title")
        .onAppear {
            messageListViewModel.markRead(message: message)
        }
    }
}

struct MessageDetailView_Previews: PreviewProvider {
    static let mockedMessage = Message(id: "123", subject: "new message", body: "The MessageDetailView now displays the message body and other properties in a VStack with increased vertical padding. The subject now uses a larger font size and is displayed in bold to make it stand out. The Date label is set as a headline for better readability.", isRead: true, images: [MessageImage(width: 480, height: 460, src: "https://www.accesso.com/imager/images/markets/market-theme-park/6681/Theme-Parks-Header-XXL_ac21bf3414a21ce27b0a0c85a113c91a.jpg")])

    internal static var previews: some View {
        debugPrint(mockedMessage)
        return MessageDetailView(messageListViewModel: MessageListViewModel(), message: mockedMessage)
    }
}
// swiftlint:enable line_length
