//
//  AppUIManager.swift
//  QueueingSample
//
//  Created by James Layton on 10/9/23.
//

import SwiftUI

class AppUIManager: ObservableObject {
    @Published var isTaskLoading = false

    @Published var alertDetails: AlertDetails?
    @Published var showAlert: Bool = false
}
