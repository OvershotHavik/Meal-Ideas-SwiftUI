//
//  MealDBDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import UIKit
import CoreData

@MainActor final class MealDBDetailVM: DetailBaseVM{
    
    @Published var meal: MealDBResults.Meal?
    @Published var mealID: String
    
    
    init(meal : MealDBResults.Meal?, favorited: Bool, mealID: String, showingHistory: Bool){
        self.mealID = mealID
        super.init()
        self.meal = meal
        self.favorited = favorited
        self.showingHistory = showingHistory
        fetchMeal()
        getMealPhoto()
        addToHistory()
    }


    func fetchMeal(){
        if meal == nil || meal?.ingredientsArray == []{
            print("No Meal Provided, Fetching MealDB Single Named mealID: \(mealID)")
            isLoading = false
            Task {
                do {
                    let results = try await NetworkManager.shared.mealDBQuery(query: mealID, queryType: .none)
                    if let safeResults = results.first{
                        meal = safeResults
                        getMealPhoto()
                        addToHistory()
                    }
                }
            }
        }
    }
    

    func getMealPhoto(){
        if meal != nil{
            NetworkManager.shared.downloadImage(fromURLString: meal?.strMealThumb ?? "") { uiImage in
                guard let uiImage = uiImage else {
                    self.mealPhoto = UIImage(imageLiteralResourceName: ImageNames.placeholderMeal.rawValue)
                    return }
                DispatchQueue.main.async {
                    self.mealPhoto = uiImage
                }
            }
        }
    }


    func favoriteToggled(){
        if let safeMeal = meal{
            if favorited == true {
                //add to favorites
                print("add to favorite")
                PersistenceController.shared.saveFavorites(mealName: safeMeal.strMeal ?? "",
                                                           mealDBID: safeMeal.id,
                                                           spoonID: nil,
                                                           userMealID: nil)
                
            } else {
                //remove from favorite
                print("remove from favorites")
                
                PersistenceController.shared.deleteFavorite(source: .mealDB,
                                                            mealName: safeMeal.strMeal ?? "",
                                                            mealDBID: safeMeal.id,
                                                            spoonID: nil,
                                                            userMealID: nil)
            }
        }
    }


    func addToHistory(){
        //Only add to history if not already showing the meal in history list
        if showingHistory == false{
            if meal != nil{
                //only add it once the meal is set, otherwise it's just a blank name and id
                print("Added meal to history: \(meal?.strMeal ?? ""), id: \(meal?.id ?? "")")
                PersistenceController.shared.addToHistory(mealName: meal?.strMeal ?? "",
                                                          mealDBID: meal?.id,
                                                          spoonID: 0,
                                                          userMealID: nil)
            }
        }
    }
}





