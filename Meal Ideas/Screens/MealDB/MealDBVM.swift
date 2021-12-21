//
//  MealDBVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import Foundation
import CoreData

@MainActor final class MealDBVM: ObservableObject{
    
    @Published var meals : [MealDBResults.Meal] = []
    @Published var alertItem : AlertItem?
    @Published var isLoading = false
    @Published var originalQueryType = QueryType.none
    @Published var originalQuery: String?
    @Published var keywordSearchTapped = false
    @Published var getMoreMeals = false
    

    
    // MARK: - CheckQuery
    func checkQuery(query: String, queryType: QueryType){
        if originalQueryType != queryType{
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            getMealDBMeals(query: query, queryType: queryType)
        } else {
            if originalQuery != query{
                meals = []
                self.originalQuery = query
                getMealDBMeals(query: query, queryType: queryType)
            } else {
                // nothing happens, query and query type didn't change
            }
        }
        
    }
    // MARK: - Get MealDBMeals
    func getMealDBMeals(query: String, queryType: QueryType) {
        isLoading = true
        print("mealdb Query : \(queryType.rawValue)")
        Task {
            do{
                switch queryType {
                case .random:
                    print("random")
                    meals = try await NetworkManager.shared.mealDBQuery(query: "", queryType: .random)

                case .category:
                    print("Fetching MealDB Category: \(query)")
                    var modified = query.replacingOccurrences(of: " ", with: "%20")
                    if modified == "Side%20Dish"{
                        modified = "Side"
                    }
                    meals = try await NetworkManager.shared.mealDBQuery(query: modified, queryType: .category)
                    
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "_")
                    
                    meals = try await NetworkManager.shared.mealDBQuery(query: modifiedIngredient,
                                                                        queryType: .ingredient)
                    print("ing")
                case .history:
                    print("hit")
                case .favorite:
                    print("fav")
                case .none:
                    ()
                    
                    
                case .keyword:
                    let modifiedKeyword = query.replacingOccurrences(of: " ", with: "%20")
                    meals = try await NetworkManager.shared.mealDBQuery(query: modifiedKeyword,
                                                                        queryType: .keyword)
                }
                isLoading = false

            }catch{
                if let miError = error as? MIError{
                    switch miError {
                        //only ones that would come through should be invalidURL or invalid data, but wanted to keep the other cases
                    case .invalidURL:
                        alertItem = AlertContext.invalidURL
                    case .invalidData:
                        alertItem = AlertContext.invalidData
                    default: alertItem = AlertContext.invalidResponse // generic error if wanted..
                    }
                } else {
                    alertItem = AlertContext.invalidResponse // generic error would go here
                    isLoading = false
                }
            }
        }
    }
    
    // MARK: - Check For Favorite
    func checkForFavorite(id: String?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.mealDBID == id}){
            print("favorited meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
    }
    // MARK: - Check For History
    func checkForHistory(id: String?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.mealDBID == id}){
            print("History meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
    }
    /*
    // MARK: - Check For Favorite
    func checkForFavorite(id: String?) -> Bool{
//        print(id ?? "")
        
        if favoritesArray.contains(where: {$0.mealDBID == id}){
            print("favorited meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
        
//        if favoritesArray.contains(where: {$0.mealDBID == meals[indexSet].id})
    }
    */
    /*
    // MARK: - Get Favorites
    func getFavorites(){
        let request = NSFetchRequest<Favorites>(entityName: EntityName.favorites.rawValue)
        do {
            let favoritesCD = try PersistenceController.shared.container.viewContext.fetch(request)
            if let first = favoritesCD.first{
                if let data = first.favoritesData{
                    do {
                        let results = try JSONDecoder().decode([FavoritesModel].self, from: data)
                        for x in results{
                            print("Meal Name: \(x.mealName)")
                            print("MealDB ID: \(x.mealDBID ?? "")")
                            print("Spoon ID: \(String(describing: x.spoonID))")
                        }
                        favoritesArray = results
                    }catch let e{
                        print("error decoding favorite data: \(e.localizedDescription)")
                    }
                }
            }

        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    func saveFavorites(){
        
    }
     */
}
