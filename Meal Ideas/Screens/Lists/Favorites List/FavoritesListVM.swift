//
//  FavoritesListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/19/21.
//

import Foundation
import CoreData

final class FavoritesListVM: ObservableObject{
    @Published var source: Source
    @Published var favoritesArray : [Favorites] = []
    @Published var searchText = ""
    var searchResults: [Favorites] {
        if searchText.isEmpty {
            return favoritesArray
        } else {
            return favoritesArray.filter { $0.mealName!.contains(searchText) }
        }
    }
    init(source: Source){
        self.source = source
    }
    // MARK: - Filtered Favorites by source
    func filteredFavorites(favorites: [Favorites]){
        switch source {
        case .spoonacular:
            let spoonFavorites = favorites.filter{$0.spoonID != 0}.sorted{$0.mealName ?? "" < $1.mealName ?? ""}
            print("Spoon Favorites: ")
            favoritesArray = spoonFavorites
        case .mealDB:
            let mealDBFavorites = favorites.filter {$0.mealDBID != nil}.sorted{$0.mealName ?? "" < $1.mealName ?? ""}
            print("MealDB Favorites: ")
            favoritesArray = mealDBFavorites
        case .myIdeas:
            let myFavorites = favorites.filter{$0.spoonID == 0 && $0.mealDBID == nil}.sorted{$0.mealName ?? "" < $1.mealName ?? ""}
            print("My Favorites")
            favoritesArray = myFavorites
        }
    }
    // MARK: - Fetch User Meal
    func fetchUserMeal(name: String?) -> UserMeals?{
        if let safeName = name{
            let request = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
            var allMeals: [UserMeals] = []
            
            do {
                allMeals = try PersistenceController.shared.container.viewContext.fetch(request)
                print("Meals Fetched in Fetch Favorite")
            }catch let e{
                print("error fetching meal in fetch Favorites: \(e.localizedDescription)")
            }
            for meal in allMeals{
                if meal.mealName == safeName{
                    return meal
                }
            }
        }
        return nil
    }
    // MARK: - Fetch Spoon Favorite
    func fetchSpoonMeal(spoonID: Double) ->  SpoonacularResults.Recipe?{
        let mealIDInt: Int = Int(spoonID)
        print("Spoon meal ID: \(mealIDInt)")
        let mealID = "\(mealIDInt)"
//        isLoading = true
        Task { () -> SpoonacularResults.Recipe? in
            do {
                let meal = try await NetworkManager.shared.spoonSingleMeal(query: mealID)
                return meal
            } catch let e{
                print(e.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Fetch MealDB Favorite
    func fetchMealDBMeal(mealDBID: String?) -> MealDBResults.Meal?{

        print("Fetching MealDB Single Named mealID: \(mealDBID ?? "")")
//        isLoading = false
        Task { () -> MealDBResults.Meal? in
            do {
                let results = try await NetworkManager.shared.mealDBQuery(query: mealDBID ?? "", queryType: .none)
                if let safeResults = results.first{
                    return safeResults
                }
            } catch let e{
                print("Error loading mealdb favorite: \(e.localizedDescription)")
                return nil
            }
            return nil
        }
        return nil
    }

     
    /*
    func filteredFavorites(favorites: [Favorites], source: Source) -> [Favorites]{
        switch source {
        case .spoonacular:
            let spoonFavorites = favorites.filter{$0.spoonID != 0}.sorted{$0.mealName ?? "" < $1.mealName ?? ""}
            print("Spoon Favorites: ")
            print(spoonFavorites)
            return spoonFavorites
        case .mealDB:
            let mealDBFavorites = favorites.filter {$0.mealDBID != nil}
            print("MealDB Favorites: ")
            print(mealDBFavorites)
            return mealDBFavorites
        case .myIdeas:
            let myFavorites = favorites.filter{$0.spoonID == 0 && $0.mealDBID == nil}
            print("My Favorites")
            print(myFavorites)
            return myFavorites
        }
    }
    */
}
