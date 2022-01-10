//
//  MyIdeasVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI
import CoreData
struct TabItem: Identifiable{
    var id = UUID()
    var meals : [UserMeals]
//    var text: String
}
@MainActor final class MyIdeasVM: BaseVM{
    @Published var meals : [UserMeals] = []
    private let pc = PersistenceController.shared
    @Published var filteredMeals: [UserMeals] = []
    @Published var allMeals : [UserMeals] = []
    @Published var source: Source = .myIdeas
    @Published var tabData : [TabItem] = [TabItem(meals: [])]
    

// MARK: - get All Meals
    func getAllMeals(){
        //used to get all meals, runs on on appear of the view, and if all meals changes, goes through check query
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        do {
            allMeals = try pc.container.viewContext.fetch(request)
//            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        if offsetBy == 0{
            offsetBy += 10
        }
        print("My Ideas Query: \(query), queryType: \(queryType.rawValue)")
        // TODO:  Add a check in here to add to the array if the query and query type haven't changed, but also make sure there are unique items still
        if originalQueryType != queryType ||
            getMoreMeals == true ||
            allMeals.count != meals.count{
            if getMoreMeals == true {
                offsetBy += 10
            }
            getMoreMeals = false
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            filterMeals(query: query, queryType: queryType)
        } else {
            if originalQuery != query{
                meals = []
                self.originalQuery = query
                filterMeals(query: query, queryType: queryType)
            } else {
                // nothing happens, query and query type didn't change
            }
        }
    }
    // MARK: - Filter Meals
    func filterMeals(query: String, queryType: QueryType){
        // TODO:  Animate the meals leaving and coming in
        getAllMeals()

        tabData = [TabItem(meals: [])] // default back to blank when switching
        switch queryType {
        case .random:
            print("My Ideas Random")
            if meals.count == 0{
                meals = allMeals
            }
//            while meals.count > 10 {
//                let tabItem = TabItem(meals: Array(meals.prefix(10)))
//                tabData.append(tabItem)
//                meals.removeFirst(10)
//            }
//            let tabItem = TabItem(meals: Array(meals)) // whatever is left over gets added after the while loop
//            tabData.append(tabItem)
//
//            if meals.count <= 10{
//                lessThanTen = true
//            }
            setupTabs()
        case .category:
            print("My Ideas category")
            for meal in allMeals{
                if let safeCategories = meal.category as? [String]{
                    if safeCategories.contains(query){
                        meals.append(meal)
                    }
                }
            }
            setupTabs()
//            let offsetMeals = catMeals.prefix(offsetBy)
//            meals = offsetMeals.shuffled()
            
        case .ingredient:
            print("My Ideas ingredients")
            for meal in allMeals{
                if let safeIngredients = meal.ingredients as? [String]{
                    if safeIngredients.contains(query){
                        meals.append(meal)
                    }
                }
            }
//            let offsetMeals = ingMeals.prefix(offsetBy)
//            meals = offsetMeals.shuffled()
            setupTabs()
        case .keyword:
            print("My Ideas keyword")
            for meal in allMeals{
                if let safeName = meal.mealName{
                    if safeName.containsIgnoringCase(find: query){
                        print("meal matches query: \(meal.mealName ?? "")")
                        meals.append(meal)
                    }
                }
            }
//            let offsetMeals = keyMeals.prefix(offsetBy)
//            meals = offsetMeals.shuffled()
            setupTabs()
            
        case .history:
            print("My Ideas History")
        case .favorite:
            print("My Ideas Favorite")
        case .none:
            print("My Ideas none")
        }
        
        if tabData.count > 1{
            tabData.removeFirst()
        }
    }
    
    // MARK: - Setup Tabs
    func setupTabs(){
        print("Meals count before while loops: \(meals.count)")
        while meals.count > offsetBy{
            print("meals.count > offsetby: \(meals.count) > \(offsetBy)")
            while meals.count > 10 {
                let tabItem = TabItem(meals: Array(meals.prefix(10)))
                tabData.append(tabItem)
                meals.removeFirst(10)
            }
        }
        print("Meals.count after while loops")
        let tabItem = TabItem(meals: Array(meals)) // whatever is left over gets added after the while loop
        tabData.append(tabItem)

        if meals.count <= 10{
            lessThanTen = true
        }
    }

    // MARK: - Check For Favorite
    func checkForFavorite(id: UUID?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.userMealID == id} ){
            
//        }
//        if favoriteArray.contains(where: {$0.mealName == id && $0.spoonID == 0 && $0.mealDBID == nil}){
//            print("favorited meal id: \(String(describing: id))")
            return true
        } else {
            return false
        }
    }
    // MARK: - Check For History
    func checkForHistory(id: String?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.mealName == id && $0.spoonID == 0 && $0.mealDBID == nil}){
//            print("History meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
    }
}

