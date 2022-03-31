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
        if recipe == ""{
            Text("No Recipe Provided")
                .font(.body)
        } else {
            Text(recipe)
                .font(.body)
        }
    }
}
