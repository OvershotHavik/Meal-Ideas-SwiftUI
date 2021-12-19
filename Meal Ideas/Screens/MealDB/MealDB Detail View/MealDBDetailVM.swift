//
//  MealDBDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import UIKit
import CoreData

@MainActor final class MealDBDetailVM: ObservableObject{
    @Published var meal: MealDBResults.Meal?
    @Published var isLoading = false
    @Published var favorited : Bool
    @Published var mealID: String
    @Published var mealPhoto = UIImage()

    
    init(meal : MealDBResults.Meal?, favorited: Bool, mealID: String){
        self.meal = meal
        self.favorited = favorited
        self.mealID = mealID
        fetchMeal()
    }
    // MARK: - Fetch Meal
    func fetchMeal(){
        if meal == nil || meal?.ingredientsArray == []{
            print("No Meal Provided, Fetching MealDB Single Named mealID: \(mealID)")
            isLoading = false
            Task {
                do {
                    let results = try await NetworkManager.shared.mealDBQuery(query: mealID, queryType: .none)
                    if let safeResults = results.first{
                        meal = safeResults
                    }
                }
            }
        }
    }
    
    // MARK: - Get Meal Photo
    func getMealPhoto(){
        if meal != nil{
            NetworkManager.shared.downloadImage(fromURLString: meal?.strMealThumb ?? "") { uiImage in
                guard let uiImage = uiImage else { return }
                DispatchQueue.main.async {
                    self.mealPhoto = uiImage
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
        if let safeMeal = meal{
            if favorited == true {
                //add to favorites
                print("add to favorite")
                PersistenceController.shared.saveFavorites(mealName: safeMeal.strMeal ?? "",
                                    mealDBID: safeMeal.id,
                                    spoonID: nil)
                
            } else {
                //remove from favorite
                print("remove from favorites")
                
                PersistenceController.shared.deleteFavorite(source: .mealDB,
                                                            mealName: safeMeal.strMeal ?? "",
                                                            mealDBID: safeMeal.id,
                                                            spoonID: nil)
            }
        }

    }
}

