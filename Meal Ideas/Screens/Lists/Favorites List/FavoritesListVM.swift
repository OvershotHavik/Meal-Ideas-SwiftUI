//
//  FavoritesListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/19/21.
//

import Foundation
import CoreData

final class FavoritesListVM: ObservableObject{
    @Published var favoritesArray : [Favorites] = []
    
    func fetchFavorite(name: String?) -> UserMeals?{
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
    
    func filteredFavorites(favorites: [Favorites], source: Source) -> [Favorites]{
        switch source {
        case .spoonacular:
            let spoonFavorites = favorites.filter{$0.spoonID != 0}
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
}
