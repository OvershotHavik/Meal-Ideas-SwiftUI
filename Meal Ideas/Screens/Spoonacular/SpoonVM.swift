//
//  SpoonVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
import CoreData

@MainActor final class SpoonVM: BaseVM{
    @Published var meals: [SpoonacularResults.Recipe] = []
    @Published var keywordResults : [SpoonacularKeywordResults.result] = []
    @Published var individualMeal: SpoonacularResults.Recipe?
    @Published var source: Source = .spoonacular

    
    // MARK: - Get Random Meals
    func getRandomMeals(){
        if isLoading == true {
            return
        }
        getRandomMeals = false
        meals = []
        getSpoonMeals(query: "", queryType: .random)
    }
    
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        if isLoading == true {
            return
        }
        if originalQueryType != queryType {
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
                offsetBy += 10
                getSpoonMeals(query: query, queryType: queryType)

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
                    let randomMeals = try await NetworkManager.shared.spoonQuery(query: query, queryType: queryType)
                    meals.append(contentsOf: randomMeals)
                    if offsetBy == 0{
                        if meals.count < 10{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                        
                    } else {
                        if meals.count < offsetBy{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                    }

                    
                case .category:
                    let modifiedCategory = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    print(modifiedCategory)
                    let modified = modifiedCategory.lowercased() + "&offset=\(offsetBy)"

                    let catMeals = try await NetworkManager.shared
                        .spoonComplexQuery(query: modified, queryType: .category)
                    meals.append(contentsOf: catMeals.results)
                    if let safeTotalResults = catMeals.totalResults{
                        totalMealCount = safeTotalResults
                    }
                    

                    if offsetBy == 0{
                        if meals.count < 10{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                        
                    } else {
                        if meals.count < offsetBy{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                    }
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    let modified = modifiedIngredient.lowercased() + "&offset=\(offsetBy)"
                    let ingMeals = try await NetworkManager.shared.spoonComplexQuery(query: modified, queryType: .ingredient)
                    meals.append(contentsOf: ingMeals.results)
                    if let safeTotalResults = ingMeals.totalResults{
                        totalMealCount = safeTotalResults
                    }
                    
                    print("ingredient")
                    if offsetBy == 0{
                        if meals.count < 10{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                        
                    } else {
                        if meals.count < offsetBy{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                    }
                case .keyword:
                    var safeKeyword = query.lowercased()
                    safeKeyword = safeKeyword.replacingOccurrences(of: " ", with: "%20")
                    print(safeKeyword)
                    print("keyword Offset: \(offsetBy)")
                    let modified = safeKeyword + "&offset=\(offsetBy)"
                    let results = try await NetworkManager.shared.spoonKeywordQuery(query: modified)
                    keywordResults.append(contentsOf: results)
                    print("keyword")
                    if offsetBy == 0{
                        if keywordResults.count < 10{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                        
                    } else {
                        if keywordResults.count < offsetBy{
                            moreToShow = false
                        } else {
                            moreToShow = true
                        }
                    }
                    
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
//            print("History meal id: \(id ?? 0)")
            return true
        } else {
            return false
        }
    }
    // MARK: - Check For Favorite
    func checkForFavorite(id: Int?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.spoonID == Double(id ?? 0)}){
//            print("favorited meal id: \(id ?? 0)")
            return true
        } else {
            return false
        }
    }
}
