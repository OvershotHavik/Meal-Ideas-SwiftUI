//
//  MealNameView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealNameView: View {
    var name: String
    var body: some View {
        Text(name)
            .font(.title)
            .multilineTextAlignment(.center)
            .padding([.bottom, .horizontal], 5)
    }
}

struct MealNameView_Previews: PreviewProvider {
    static var previews: some View {
        MealNameView(name: "test name")
    }
}
