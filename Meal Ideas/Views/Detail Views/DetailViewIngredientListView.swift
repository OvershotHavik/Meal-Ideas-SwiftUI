//
//  IngredientListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/3/22.
//

import SwiftUI

struct DetailViewIngredientListView: View {
    var ingredients: [String]
    var measurements: [String]
    var body: some View {
        ForEach(ingredients.indices, id: \.self) { i in
            DetailViewIngredientCell(ingredient: ingredients[i],
                                     measurement: measurements[i],
                                     selected: false)
        }
    }
}

/*
struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewIngredientListView()
    }
}
*/
