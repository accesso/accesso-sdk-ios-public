//
//  QueueingHomeView.swift
//  QueueingSample
//
//  Created by Vy Le on 10/2/23.
//

import SwiftUI
import AccessoCore

struct QueueingHomeView: View {
    @EnvironmentObject private var appUIManager: AppUIManager

    let coreToken: CoreToken

    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 16) {
                    NavigationLink {
                        AttractionListView()
                    } label: {
                        CustomButton(title: "View Attractions")
                    }
                }
                .navigationTitle("Queueing")
                .navigationBarTitleDisplayMode(.inline)
            }

            CustomProgress(isVisible: appUIManager.isTaskLoading)
        }
        .alert(with: $appUIManager.showAlert, alertDetails: $appUIManager.alertDetails)
    }
}

struct QueueingHomeView_Previews: PreviewProvider {
    static var previews: some View {
        QueueingHomeView(coreToken: CoreToken(accessToken: "", refreshToken: "", expiresIn: Date().timeIntervalSince1970, iat: 0))
    }
}
