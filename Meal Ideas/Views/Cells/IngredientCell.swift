//
//  IngredientCell.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct IngredientCell: View {
    var ingredient: Ingredients.Meals
    
    var body: some View {
        let modifiedMealDB = ingredient.strIngredient.replacingOccurrences(of: " ", with: "%20")
        if let mealDBImages = URL(string: "\(BaseURL.ingredientImage)\(modifiedMealDB).png"){
            ZStack(alignment: .leading){
//                Color.blue // only applies to the cell, not the list
                
                HStack{
                    LoadRemoteImageView(urlString: mealDBImages.absoluteString)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    Text(ingredient.strIngredient)
                        .font(.body)
                        .padding(.horizontal)
                }
            }
        }
    }
}
/*
struct IngredientCell_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCell(ingredient: Ingredients.Meals)
    }
}
*/
