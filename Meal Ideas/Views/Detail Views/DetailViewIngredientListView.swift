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
    var mealName: String
    @State var checkedOff = false // use the function to verify later
    var body: some View {
        ForEach(ingredients.indices, id: \.self) { i in
            DetailViewIngredientCell(ingredient: ingredients[i],
                                     measurement: measurements[i],
                                     selected: checkedOff,
                                     mealName: mealName)
        }
        .frame(height: 50)
    }
}

/*
struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewIngredientListView()
    }
}
*/
