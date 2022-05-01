//
//  BackgroundGradientView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/31/21.
//

import SwiftUI

struct BackgroundGradientView: View {
    @EnvironmentObject var userEnvironment: UserEnvironment
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [
            userEnvironment.topLeftColor,
            userEnvironment.bottomRightColor
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}
