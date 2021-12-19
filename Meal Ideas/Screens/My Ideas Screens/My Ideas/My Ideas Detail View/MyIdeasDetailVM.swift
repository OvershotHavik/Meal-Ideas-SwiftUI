//
//  MyIdeasDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

final class MyIdeasDetailVM: ObservableObject{
    
    @Published var  meal: UserMeals?
    @Published var favorited : Bool

    init(meal: UserMeals?, favorited: Bool){
        self.meal = meal
        self.favorited = favorited
//        convertData()
    }
    // MARK: - Favorite Toggled
    func favoriteToggled(){
        if favorited == true {
            //add to favorites
            print("add to favorite")
            if let safeMeal = meal{
                PersistenceController.shared.saveFavorites(mealName: safeMeal.mealName ?? "",
                                    mealDBID: nil,
                                    spoonID: nil)
            }

            
        } else {
            //remove from favorite
            print("remove from favorites")
            if let safeMeal = meal {
                PersistenceController.shared.deleteFavorite(source: .mealDB,
                                                            mealName: safeMeal.mealName ?? "",
                                                            mealDBID: nil,
                                                            spoonID: nil)
            }

        }
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
