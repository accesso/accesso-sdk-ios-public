//
//  MessageRowView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 5/1/23.
//
// swiftlint:disable line_length

import SwiftUI
import AccessoCore
import AccessoExperiencePromoter

/// A view for each row of the list of message
struct MessageRowView: View {
    /// The message to display in this row.
    var message: Message
    
    /// A date formatter for formatting the message's date.
    let dateFormatter = DateFormatter()
    
    /// Initializes the row view with a message.
    init(message: Message) {
        self.message = message
        dateFormatter.dateStyle = .long
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // A circle indicator to show if the message is read (clear for read, blue for unread).
                Circle()
                    .fill(UserDefaults.standard.bool(forKey: message.id) ? .clear : .blue)
                    .frame(width: 10, height: 10)

                AsyncImageView(
                    imageURL: message.images?.first?.src,
                    cornerRadius: 30,
                    size: CGSize(width: 60, height: 60),
                    showSpinner: false
                )
                
                // Display the message's subject and body.
                VStack(alignment: .leading) {
                    Text(message.subject ?? "No Subject")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .padding(.bottom, 2)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(message.body ?? "No Body")
                        .font(.system(size: 14))
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
                .padding(.leading, 4)
            }
        }
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let mockedMessage = Message(id: "123", subject: "new message", body: "The MessageDetailView now displays the message body and other properties in a VStack with increased vertical padding. The subject now uses a larger font size and is displayed in bold to make it stand out. The Date label is set as a headline for better readability.", isRead: true, images: [MessageImage(width: 480, height: 460, src: "https://www.accesso.com/imager/images/markets/market-theme-park/6681/Theme-Parks-Header-XXL_ac21bf3414a21ce27b0a0c85a113c91a.jpg")])
        MessageRowView(message: mockedMessage)
    }
}

// swiftlint:enable line_length
