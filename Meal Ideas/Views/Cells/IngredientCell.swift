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
                if selected{
                    withAnimation(.easeIn(duration: 0.25).delay(0.25)){
                        Image(systemName: SFSymbols.check.rawValue)
                        .padding(.horizontal, 5)
                    }
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 18)
                        .padding(.horizontal, 5)
                }
                LoadRemoteImageView(urlString: mealDBImages.absoluteString)
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                Text(ingredient.strIngredient)
                    .font(.body)
                    .padding(.horizontal)
            }
            .contentShape(Rectangle().size(width: .infinity, height: .infinity))
            .frame(height: 50)
        }
    }
}
