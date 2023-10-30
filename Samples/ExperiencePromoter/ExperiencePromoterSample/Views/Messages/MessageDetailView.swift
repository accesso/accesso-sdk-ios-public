//
//  MessageDetailView.swift
//  Views
//
//  Created by Vy Le on 1/25/23.
//

import SwiftUI
import AccessoCore
import AccessoExperiencePromoter

/// A view to show the message information
struct MessageDetailView: View {
    
    @ObservedObject var messageListViewModel: MessageListViewModel
    var message: Message

    private let dateFormatter = DateFormatter()
    private var formattedDate: String {
        return dateFormatter.string(from: message.publishTime ?? Date())
    }

    init(messageListViewModel: MessageListViewModel, message: Message) {
        self.messageListViewModel = messageListViewModel
        self.message = message
        self.dateFormatter.dateStyle = .long
    }

    var body: some View {
        if let url = URL(string: message.images?.first?.url ?? "")  {
            AsyncImage(
                url: url,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(minWidth: 200, minHeight: 200)
        } else {
            Image("placeholderImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
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
    static let mockedMessage = Message(id: "123", subject: "new message", body: "The MessageDetailView now displays the message body and other properties in a VStack with increased vertical padding. The subject now uses a larger font size and is displayed in bold to make it stand out. The Date label is set as a headline for better readability.", isRead: true, images: [MessageImage(width: 480, height: 460, url: "https://www.accesso.com/imager/images/markets/market-theme-park/6681/Theme-Parks-Header-XXL_ac21bf3414a21ce27b0a0c85a113c91a.jpg")])

    internal static var previews: some View {
        debugPrint(mockedMessage)
        return MessageDetailView(messageListViewModel: MessageListViewModel(), message: mockedMessage)
    }
}
