//
//  MealView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealView: View {

    var meal : SampleUserMealModel
    var body: some View {
        VStack{
            Text(meal.mealName)
            Text(meal.recipe)
        }
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView(meal: MockData.userMealSample)
    }
}
