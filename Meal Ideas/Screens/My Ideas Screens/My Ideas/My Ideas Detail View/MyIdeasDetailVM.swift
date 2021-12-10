//
//  MyIdeasDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

final class MyIdeasDetailVM: ObservableObject{
    
    @Published var  meal: UserMeals
    init(meal: UserMeals){
        self.meal = meal
//        convertData()
    }
    
//    func convertData(){
//        if let safeData = meal.ingredientMealsData{
//            do {
//                let results = try JSONDecoder().decode([Ingredients.Meals].self, from: safeData)
//                for x in results {
//                    ingredients.append(x.strIngredient)
//                    measurements.append(x.strMeasurement)
//                }
//
//            } catch let e {
//                print("error decoding from core data meal: \(e.localizedDescription)")
//            }
//        }
//    }
}
