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
    @Published var tabData: [TabItem] = [TabItem(meals: [], tag: 1)]
    
    struct TabItem: Identifiable{
        var id = UUID()
        var meals: [MealDBResults.Meal]
        var tag: Int
    }
    
    
    // MARK: - CheckQuery
    func checkQuery(query: String, queryType: QueryType){
        if originalQueryType != queryType || getRandomMeals == true{
            if getRandomMeals == true{
                self.getRandomMeals = false
            }
//            getRandomMeals = false
            meals = []
            tabData = [TabItem(meals: [], tag: 1)] // default back to blank when switching, without this we get index out of range since tabData has to have at least one tab
            self.originalQuery = query
            self.originalQueryType = queryType
            getMealDBMeals(query: query, queryType: queryType)
        } else {
            if originalQuery != query {
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
                    let newMeals = try await NetworkManager.shared.mealDBQuery(query: "", queryType: .random)
                    meals.append(contentsOf: newMeals)
                    setupTabs()
                    
                    
                case .category:

                    print("Fetching MealDB Category: \(query)")
                    var modified = query.replacingOccurrences(of: " ", with: "%20")
                    if modified == "Side%20Dish"{
                        modified = "Side"
                    }
                    meals = try await NetworkManager.shared.mealDBQuery(query: modified, queryType: .category)
                    totalMealCount = meals.count

                    setupTabs()
                    
                    
                case .ingredient:
                    print("ingredient")
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "_")
                    
                    meals = try await NetworkManager.shared.mealDBQuery(query: modifiedIngredient,
                                                                        queryType: .ingredient)
                    totalMealCount = meals.count
                    setupTabs()
                    
                    
                    
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
                    totalMealCount = meals.count
                    setupTabs()
                }
                isLoading = false
                
                if firstRun == true {
                    if tabData.count > 1{
                        tabData.removeFirst()
                    }
                    firstRun = false
                }


 


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
    
    
    // MARK: - Setup Tabs
    func setupTabs(){
        print("Meals count before: \(meals.count)")
        if meals.count > 10 {
            //Takes the first 10 of the array and puts them on a new tab
            let tenMeals = Array(meals.prefix(10))
            let tabItem = TabItem(meals: tenMeals, tag: newTag)
            tabData.append(tabItem)
            meals.removeFirst(10)
            
        } else {
            if meals.count == 0{
                moreToShow = false
                return
            }
            //Add remaining meals to the last page
            let tabItem = TabItem(meals: Array(meals), tag: newTag)
            tabData.append(tabItem)
            meals = []
        }
        print("Meals.count after: \(meals.count)")
        selectedTab = newTag
        
        
        if originalQueryType == .random{
            moreToShow = true
        } else {
            if meals.count == 0{
                moreToShow = false
            } else {
                moreToShow = true
            }
        }
        
    }
    
    // MARK: - Get More Meals
    func getMore(){
        if originalQueryType == .random{
            getMealDBMeals(query: originalQuery, queryType: originalQueryType)
        }
        getMoreMeals = false
        newTag += 1
        setupTabs()
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
