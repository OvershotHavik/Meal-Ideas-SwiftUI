//
//  IngredientVGrid.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct IngredientVGrid: View {
    var ingredients : [String]
    var measurements: [String?]
//    var spoonIngredients: [SpoonacularResults.ExtendedIngredients]?
    let columns = [GridItem(), GridItem()]
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center){
            ForEach(ingredients.indices, id: \.self) { i in
                IngredientView(name: ingredients[i],
                               value: measurements[i],
                               image: "Pizza")
            }
        }

    }
}



struct IngredientVGrid_Previews: PreviewProvider {
    static var previews: some View {
        IngredientVGrid(ingredients: ["Cheese", "Pepperoni"], measurements: ["2 cups", "15"])
    }
}
