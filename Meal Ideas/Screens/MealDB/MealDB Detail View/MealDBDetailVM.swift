//
//  MealDBDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
import CoreData

@MainActor final class MealDBDetailVM: ObservableObject{
    @Published var meal: MealDBResults.Meal
    @Published var isLoading = false
    @Published var favorited : Bool
    
    init(meal : MealDBResults.Meal, favorited: Bool){
        self.meal = meal
        self.favorited = favorited
        fetchMeal()
    }
    // MARK: - Fetch Meal
    func fetchMeal(){
        let mealID = meal.id
        print("Fetching MealDB Single Named mealID: \(mealID ?? "")")
        isLoading = false
        Task {
            do {
                let results = try await NetworkManager.shared.mealDBQuery(query: mealID ?? "", queryType: .none)
                if let safeResults = results.first{
                    meal = safeResults
                }
            }
        }
    }
    
    /*
    // MARK: - Get Favorites
    func getFavorites(){
        let request = NSFetchRequest<Favorites>(entityName: EntityName.favorites.rawValue)
        do {
            favoritesArray = try PersistenceController.shared.container.viewContext.fetch(request)
            print("favorites count: \(favoritesArray.count)")
            for x in favoritesArray{
                print("Meal Name: \(x.mealName ?? "")")
                print("MealDB ID: \(x.mealDBID ?? "")")
                print("Spoon ID: \(String(describing: x.spoonID))")
                print("______________________")
            }
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    func saveFavorites(){
        
        let newFavorite = Favorites(context: PersistenceController.shared.container.viewContext)
        newFavorite.mealDBID = meal.id

        if let safeName = meal.strMeal{
            newFavorite.mealName = safeName
            print("Added \(safeName) to favorites")
        }
        PersistenceController.shared.saveData()
        getFavorites() // remove once verified working
    }
*/
    // MARK: - Favorite Toggled
    func favoriteToggled(){
        if favorited == true {
            //add to favorites
            print("add to favorite")
            PersistenceController.shared.saveFavorites(mealName: meal.strMeal ?? "",
                                mealDBID: meal.id,
                                spoonID: nil)
            
        } else {
            //remove from favorite
            print("remove from favorites")
            
            PersistenceController.shared.deleteFavorite(source: .mealDB,
                                                        mealName: meal.strMeal ?? "",
                                                        mealDBID: meal.id,
                                                        spoonID: nil)
        }
    }
}

