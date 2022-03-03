//
//  MIButtonModifier.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 3/3/22.
//

import SwiftUI

struct MIButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(.blue)
            .cornerRadius(10)
            .padding(.bottom)
    }
}


