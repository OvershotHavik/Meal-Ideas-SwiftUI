//
//  MealDBDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealDBDetailView: View {
    var meal: MealDBResults.Meal
    
    var body: some View {
        Text(meal.strMeal ?? "")
    }
}

/*
struct MealDBDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDBDetailView(meal: MealDBResults.Meal())
    }
}
*/
