//
//  MealDBVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import Foundation
import CoreData


@MainActor final class MealDBVM: BaseVM{
    
    @Published var meals : [MealDBResults.Meal] = []
    @Published var source: Source = .mealDB

    
    // MARK: - CheckQuery
    func checkQuery(query: String, queryType: QueryType){
        if originalQueryType != queryType  {
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            getMealDBMeals(query: query, queryType: queryType)
        } else {
            if originalQuery != query {
                meals = []
                self.originalQuery = query
                getMealDBMeals(query: query, queryType: queryType)
            } else {
                //run through again and add to the array
                getMealDBMeals(query: query, queryType: queryType)
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
                    let newMeals = try await NetworkManager.shared.mealDBQuery(query: "", queryType: .random)
                    meals.append(contentsOf: newMeals)
                    
                case .category:
                    print("Fetching MealDB Category: \(query)")
                    var modified = query.replacingOccurrences(of: " ", with: "%20")
                    if modified == "Side%20Dish"{
                        modified = "Side"
                    }
                    meals = try await NetworkManager.shared.mealDBQuery(query: modified, queryType: .category)
                    allResultsShown = true
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "_")
                    
                    meals = try await NetworkManager.shared.mealDBQuery(query: modifiedIngredient,
                                                                        queryType: .ingredient)
                    allResultsShown = true
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
                    allResultsShown = true
                    
                }
                isLoading = false
                totalMealCount = meals.count
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
//            print("favorited meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
    }
    // MARK: - Check For History
    func checkForHistory(id: String?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.mealDBID == id}){
//            print("History meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
    }
   
}
