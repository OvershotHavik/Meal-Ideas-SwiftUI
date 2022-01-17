//
//  BackgroundGradientView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/31/21.
//

import SwiftUI

struct BackgroundGradientView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(uiColor: Color.lightBlue), Color(uiColor: Color.darkBlue)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
    }
}

struct BackgroundGradientView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundGradientView()
    }
}
