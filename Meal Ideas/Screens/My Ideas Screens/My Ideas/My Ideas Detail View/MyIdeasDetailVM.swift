//
//  MyIdeasDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

final class MyIdeasDetailVM: DetailBaseVM{
    
    @Published var meal: UserMeals?
    @Published var instructionsPhoto = UIImage()
    init(meal: UserMeals?, favorited: Bool, showingHistory: Bool){
        self.meal = meal
        super.init()
        self.favorited = favorited
        self.showingHistory = showingHistory
        addToHistory()
    }
    // MARK: - Favorite Toggled
    func favoriteToggled(){
        if favorited == true {
            //add to favorites
            if let safeMeal = meal{
                PersistenceController.shared.saveFavorites(mealName: safeMeal.mealName ?? "",
                                                           mealDBID: nil,
                                                           spoonID: nil,
                                                           userMealID: safeMeal.userMealID)
                print("add to favorite")
            }
        } else {
            //remove from favorite
            if let safeMeal = meal {
                PersistenceController.shared.deleteFavorite(source: .mealDB,
                                                            mealName: safeMeal.mealName ?? "",
                                                            mealDBID: nil,
                                                            spoonID: nil,
                                                            userMealID: safeMeal.userMealID)
                print("remove from favorites")
            }
        }
    }
    // MARK: - Add To History
    func addToHistory(){
        //Only add to history if not already showing the meal in history list
        if showingHistory == false{
            if meal != nil{
                //only add it once the meal is set, otherwise it's just a blank name and id
                print("Added meal to history: \(meal?.mealName ?? "")")
                PersistenceController.shared.addToHistory(mealName: meal?.mealName ?? "",
                                                          mealDBID: nil,
                                                          spoonID: 0,
                                                          userMealID: meal?.userMealID)
            }
        }
    }
    
    func shareIngredientTapped(ingredientsToShare: [String]){
        if let safeMeal = meal{
            var shareMessage = "\(safeMeal.mealName ?? "")\n"
            for i in ingredientsToShare{
                shareMessage += "\(i)\n"
            }
            print(shareMessage)
        }
        
    }
}
