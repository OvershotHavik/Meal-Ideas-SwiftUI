//
//  IngredientCell.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct IngredientCell: View {
    var ingredient: Ingredients.Meals
    var selected: Bool

    var body: some View {
        let modifiedMealDB = ingredient.strIngredient.replacingOccurrences(of: " ", with: "%20")
        if let mealDBImages = URL(string: "\(BaseURL.ingredientImage)\(modifiedMealDB).png"){
            HStack{
                LoadRemoteImageView(urlString: mealDBImages.absoluteString)
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                Text(ingredient.strIngredient)
                    .font(.body)
                    .padding(.horizontal)
                Spacer()
                if selected == true{
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .frame(height: 50)
        }
    }
}
