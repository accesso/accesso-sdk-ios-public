//
//  ViewModifiers.swift
//  ExperiencePromoterSample
//
//  Created by Vy Le on 5/1/23.
//

import SwiftUI

extension Image {
    func circleImageModifier() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .cornerRadius(30)
    }
}
