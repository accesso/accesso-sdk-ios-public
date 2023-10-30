//
//  AttractionListView.swift
//  QueueingSample
//
//  Created by Vy Le on 10/2/23.
//

import SwiftUI
import AccessoQueueing

struct AttractionListView: View {
    @EnvironmentObject private var appUIManager: AppUIManager
    @StateObject private var attractionVM = AttractionViewModel()

    var body: some View {
        ZStack {
            List {
                ForEach(attractionVM.attractions) { attraction in
                    NavigationLink {
                        AttractionDetailView(attractionVM: attractionVM, attractionId: attraction.id)
                    } label: {
                        AttractionRowView(attraction: attraction)
                    }
                }

            }
            .listStyle(.plain)
            .navigationTitle("Attractions")
        }
        .task {
            appUIManager.isTaskLoading = true
            do {
                try await attractionVM.getAttractions()
            } catch {
                showAlert(error.localizedDescription)
            }
            appUIManager.isTaskLoading = false
        }
    }

    func showAlert(_ message: String) {
        appUIManager.showAlert = true
        appUIManager.alertDetails = AlertDetails(title: "", message: message)
    }
}

struct AttractionListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AttractionListView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
