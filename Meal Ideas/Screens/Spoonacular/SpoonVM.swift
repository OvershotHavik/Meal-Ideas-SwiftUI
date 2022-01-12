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
    @Published var tabData: [TabItem] = [TabItem(meals: [], keywordMeals: [], tag: 1)]
    
    struct TabItem: Identifiable{
        var id = UUID()
        var meals: [SpoonacularResults.Recipe]
        var keywordMeals: [SpoonacularKeywordResults.result]
        var tag: Int
    }
    
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        if originalQueryType != queryType || getMoreMeals == true {
            if getMoreMeals == true{
                offsetBy += 10
            }
            if firstRun == true {
                tabData = [TabItem(meals: [], keywordMeals: [], tag: 1)] // default back to blank when switching, without this we get index out of range since tabData has to have at least one tab
            }
            getMoreMeals = false
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
                    meals = try await NetworkManager.shared.spoonQuery(query: query, queryType: queryType)
                    if meals.count == 10{
                        moreToShow = true
                    } else {
                        moreToShow = false
                    }
                    setupTabs()
                    
                    
                case .category:
                    let modifiedCategory = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    print(modifiedCategory)
                    meals = try await NetworkManager.shared
                        .spoonQuery(query: modifiedCategory, queryType: .category)
                    if meals.count == 10{
                        moreToShow = true
                    } else {
                        moreToShow = false
                    }
                    setupTabs()
                    
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    let modified = modifiedIngredient.lowercased() + "&offset=\(offsetBy)"
                    meals = try await NetworkManager.shared.spoonQuery(query: modified, queryType: .ingredient)
                    print("ingredient")
                    if meals.count == 10{
                        moreToShow = true
                    } else {
                        moreToShow = false
                    }
                    setupTabs()
                    
                    
                case .keyword:
                    var safeKeyword = query.lowercased()
                    safeKeyword = safeKeyword.replacingOccurrences(of: " ", with: "%20")
                    print(safeKeyword)
                    print("keyword Offset: \(offsetBy)")
                    let modified = safeKeyword + "&offset=\(offsetBy)"
                    keywordResults = try await NetworkManager.shared.spoonKeywordQuery(query: modified)
                    print("keyword")
                    if keywordResults.count == 10{
                        if keywordResults.count != 0{
                            moreToShow = true
                        } else {
                            moreToShow = false
                        }
                    }
                    
//                    setupTabs()
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
            
            if firstRun == true {
                if tabData.count > 1{
                    tabData.removeFirst()
                }
                firstRun = false
            }
        }
    }
    // MARK: - Setup Tabs
    func setupTabs(){
        print("Meals count before: \(meals.count)")
        if meals.count > 10 {
            //Takes the first 10 of the array and puts them on a new tab
            let tenMeals = Array(meals.prefix(10))
            let tabItem = TabItem(meals: tenMeals, keywordMeals: [], tag: newTag)
            tabData.append(tabItem)
            meals.removeFirst(10)
            
        } else {
            if meals.count < 10{
                moreToShow = false
            }
            //Add remaining meals to the last page
            let tabItem = TabItem(meals: Array(meals), keywordMeals: [], tag: newTag)
            tabData.append(tabItem)
            meals = []
        }
        print("Meals.count after: \(meals.count)")
        selectedTab = newTag
        
        
//        if originalQueryType == .random{
//            moreToShow = true
//        } else {
//            if meals.count == 0{
//                moreToShow = false
//            } else {
//                moreToShow = true
//            }
//        }
        
    }
    
    // MARK: - Get More Meals
    func getMore(){
//        getMoreMeals = false
        newTag += 1
        checkQuery(query: originalQuery, queryType: originalQueryType)
//        setupTabs()
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
