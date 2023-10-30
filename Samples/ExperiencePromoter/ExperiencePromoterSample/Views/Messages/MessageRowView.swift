//
//  MessageRowView.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 5/1/23.
//

import SwiftUI
import AccessoCore
import AccessoExperiencePromoter

/// A view for each row of the list of message
struct MessageRowView: View {
    var message: Message
    
    let dateFormatter = DateFormatter()
    
    init(message: Message) {
        self.message = message
        dateFormatter.dateStyle = .long
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Circle()
                    .fill(UserDefaults.standard.bool(forKey: message.id) ? .clear : .blue)
                    .frame(width: 10, height: 10)
                if let url = URL(string: message.images?.first?.url ?? "") {
                    AsyncImage(
                        url: url,
                        content: { image in
                            image.circleImageModifier()
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                    .frame(width: 60, height: 60)
                } else {
                    Image("placeholderImage")
                        .circleImageModifier()
                }
                
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
        let mockedMessage = Message(id: "123", subject: "new message", body: "The MessageDetailView now displays the message body and other properties in a VStack with increased vertical padding. The subject now uses a larger font size and is displayed in bold to make it stand out. The Date label is set as a headline for better readability.", isRead: true, images: [MessageImage(width: 480, height: 460, url: "https://www.accesso.com/imager/images/markets/market-theme-park/6681/Theme-Parks-Header-XXL_ac21bf3414a21ce27b0a0c85a113c91a.jpg")])
        MessageRowView(message: mockedMessage)
    }
}
