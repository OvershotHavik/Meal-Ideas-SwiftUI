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
    @Published var historyArray : [History] = []
    
    // MARK: - Get Favorites
    func getFavorites(){
        let request = NSFetchRequest<Favorites>(entityName: EntityName.favorites.rawValue)
        do {
            favoritesArray = try PersistenceController.shared.container.viewContext.fetch(request)
            print("favorites count: \(favoritesArray.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Get History
    
    func getHistory(){
        let request = NSFetchRequest<History>(entityName: EntityName.history.rawValue)
        do {
            historyArray = try PersistenceController.shared.container.viewContext.fetch(request)
            print("History count: \(historyArray.count)")
        } catch let e {
            print("error fetching history: \(e.localizedDescription)")
        }
    }
    

}
