//
//  SpoonVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
import CoreData

@MainActor final class SpoonVM: BaseVM, ObservableObject{
    @Published var meals: [SpoonacularResults.Recipe] = []
    @Published var offsetBy = 0 // changes by 10 for ingredients and keyword each time get more meals is tapped, since it will always start with the same meals, this would give the user an option to get more, may end up doing a random number or something for this later, but it is working for now.
    @Published var keywordResults : [SpoonacularKeywordResults.result] = []
    @Published var individualMeal: SpoonacularResults.Recipe?
    @Published var source: Source = .spoonacular
    
    // MARK: - Get More Tapped
    func getMoreTapped(){
        getMoreMeals = false
        if let safeQuery = self.originalQuery{
            getSpoonMeals(query: safeQuery,
                           queryType: self.originalQueryType)
        }
    }
    
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        if originalQueryType != queryType {
            if getMoreMeals == true{
                offsetBy += 10
            }
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            getSpoonMeals(query: query, queryType: queryType)
        } else {
            if originalQuery != query{
                meals = []
                self.originalQuery = query
                getSpoonMeals(query: query, queryType: queryType)
            } else {
                // nothing happens, query and query type didn't change
            }
        }
    }
    
    
    // MARK: - Get Spoon Meals
    func getSpoonMeals(query: String, queryType: QueryType){
        isLoading = true
        print("Spoon query: \(query) Type: \(queryType.rawValue)")
        Task {
            do {
                switch queryType{
                case .random:
                    let newMeals = try await NetworkManager.shared.spoonQuery(query: query, queryType: queryType)
                    meals.append(contentsOf: newMeals)
                    
                case .category:
                    let modifiedCategory = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    print(modifiedCategory)
                    let newMeals = try await NetworkManager.shared
                        .spoonQuery(query: modifiedCategory, queryType: .category)
                    meals.append(contentsOf: newMeals)

                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    let modified = modifiedIngredient.lowercased() + "&offset=\(offsetBy)"
                    let newMeals = try await NetworkManager.shared.spoonQuery(query: modified, queryType: .ingredient)
                    meals.append(contentsOf: newMeals)
                    print("ingredient")
                    
                    
                case .keyword:
                    var safeKeyword = query.lowercased()
                    safeKeyword = safeKeyword.replacingOccurrences(of: " ", with: "%20")
                    print(safeKeyword)
                    print("keyword Offset: \(offsetBy)")
                    let modified = safeKeyword + "&offset=\(offsetBy)"
                    let newKeywordResults = try await NetworkManager.shared.spoonKeywordQuery(query: modified)
                    keywordResults.append(contentsOf: newKeywordResults)

                    print("keyword")
                case .history:
                    print("History")
                case .favorite:
                    print("Favorites")
                case .none:
                    let meal = try await NetworkManager.shared.spoonQuery(query: query, queryType: .none)
                    if let safeMeal = meal.first{
                        individualMeal = safeMeal
                    }
                }
                isLoading = false
            } catch {
                if let miError = error as? MIError{
                    isLoading = false

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

    // MARK: - Get Meal From ID
    func getMealFromID(mealID: Int) async -> SpoonacularResults.Recipe?{
        
        getSpoonMeals(query: "\(mealID)", queryType: .none)
        if let safeMeal = individualMeal{
            return safeMeal
        }
        return nil
    }
    

    // MARK: - Check For History
    func checkForHistory(id: Int?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.spoonID == Double(id ?? 0)}){
            print("History meal id: \(id ?? 0)")
            return true
        } else {
            return false
        }
    }
    // MARK: - Check For Favorite
    func checkForFavorite(id: Int?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.spoonID == Double(id ?? 0)}){
            print("favorited meal id: \(id ?? 0)")
            return true
        } else {
            return false
        }
    }
}
