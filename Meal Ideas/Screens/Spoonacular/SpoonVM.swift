//
//  SpoonVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation

@MainActor final class SpoonVM: ObservableObject{
    @Published var meals: [SpoonacularResults.Recipe] = []
    
    @Published var alertItem : AlertItem?
    @Published var isLoading = false
    @Published var originalQueryType = QueryType.none
    @Published var originalQuery: String?
    @Published var keywordSearchTapped = false
    @Published var offsetBy = 0
    @Published var keywordResults : [SpoonacularKeywordResults.result] = []
    @Published var individualMeal: SpoonacularResults.Recipe?
    
    func checkQuery(query: String, queryType: QueryType){
        
        if originalQueryType != queryType{
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
    
    
    
    func getSpoonMeals(query: String, queryType: QueryType){
        isLoading = true
        print("Spoon query: \(query) Type: \(queryType.rawValue)")
        Task {
            do {
                switch queryType{
                case .random:
                    meals = try await NetworkManager.shared.spoonQuery(query: query, queryType: queryType)
                    
                    
                case .category:
                    let modifiedCategory = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    print(modifiedCategory)
                    meals = try await NetworkManager.shared
                        .spoonQuery(query: modifiedCategory, queryType: .category)
                   
                    
                case .ingredient:
//                    print("Ingredient Offset: \(String(describing: self.offsetBy))")
                    meals = try await NetworkManager.shared.spoonQuery(query: query.lowercased(), queryType: .ingredient)
                    
                    
                    print("ingredient")
                case .keyword:
                    var safeKeyword = query.lowercased()
                    safeKeyword = safeKeyword.replacingOccurrences(of: " ", with: "%20")
                    print(safeKeyword)
                    print("keyword Offset: \(offsetBy)")
                    
                    keywordResults = try await NetworkManager.shared.spoonKeywordQuery(query: safeKeyword)
                    
//                    for meal in keywordResults{
//                        print(meal.title)
//                    }
                    // TODO:  figure out how to get the meal card to populate with the results here instead of the meal since it is different

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
//        do{
//            if let data = SpoonJSON.sample.data(using: .utf8){
//                let results = try JSONDecoder().decode(SpoonacularResults.DataResults.self, from: data)
//                self.meals = results.recipes
//                for x in results.recipes{
//                    print(x.title)
//                }
//            }
//        }catch let e{
//            print(e)
//        }
//    }
    
    func getMealFromID(mealID: Int) async -> SpoonacularResults.Recipe?{
        
        getSpoonMeals(query: "\(mealID)", queryType: .none)
        if let safeMeal = individualMeal{
            return safeMeal
        }
        return nil
    }
    
}
