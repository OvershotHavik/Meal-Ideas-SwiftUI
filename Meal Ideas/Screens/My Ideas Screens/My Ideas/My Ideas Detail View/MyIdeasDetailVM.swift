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
    @Published var showingHistory : Bool

    init(meal: UserMeals?, favorited: Bool, showingHistory: Bool){
        self.meal = meal
        self.favorited = favorited
        self.showingHistory = showingHistory
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
    // MARK: - Add To History
    func addToHistory(){
        //Only add to history if not already showing the meal in history list
        if showingHistory == false{
            if meal != nil{
                //only add it once the meal is set, otherwise it's just a blank name and id
                print("Added meal to history: \(meal?.mealName ?? "")")
                PersistenceController.shared.addToHistory(mealName: meal?.mealName ?? "",
                                                          mealDBID: nil,
                                                          spoonID: 0)
            }
        }
    }

}
