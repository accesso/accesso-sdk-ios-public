//
//  ReservationButtonsView.swift
//  QueueingSample
//
//  Created by James Layton on 10/18/23.
//

import SwiftUI
import AccessoQueueing

struct ReservationButtonsView: View {
    @ObservedObject var attractionVM: AttractionViewModel
    let attraction: Attraction
    @Binding var showPickSeatView: Bool

    var body: some View {
        ScrollView {
            ForEach(attraction.reserveActions) { reserveAction in
                Button {
                    attractionVM.reserveAction = reserveAction
                    showPickSeatView = true
                } label: {
                    CustomButton(title: reserveAction.description)
                }
            }
        }
    }
}

struct ReservationButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationButtonsView(attractionVM: AttractionViewModel(),
                               attraction: AttractionViewModel().attraction!,
                               showPickSeatView: .constant(true))
    }
}
