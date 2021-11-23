//
//  RecipeView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct RecipeView: View {
    var recipe: String
    var body: some View {
        Text(recipe)
            .font(.body)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: "recipe here")
    }
}
