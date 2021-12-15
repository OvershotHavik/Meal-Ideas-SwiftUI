//
//  Query.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
import CoreData
enum QueryType: String{
    case random = "Random"
    case category = "Category"
    case ingredient = "Ingredient"
    case keyword = "Keyword"
    case history = "book"
    case favorite = "heart.fill"
    case none = "None"
}
enum QueryName: String{
    case ingredients = "Ingredients"
    case category = "Category"
    case random = "Random"
    case keyword = "Keyword"
    case favorites = "Favorites"
    case sides = "Sides"
}


final class Query: ObservableObject{
    @Published var queryType = QueryType.random
    @Published var selected : String?
    @Published var keyword = ""
    @Published var favoritesArray : [Favorites] = []
    
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
    

}
