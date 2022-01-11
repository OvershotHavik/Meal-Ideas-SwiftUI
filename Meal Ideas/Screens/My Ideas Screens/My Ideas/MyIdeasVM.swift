//
//  MyIdeasVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI
import CoreData


@MainActor final class MyIdeasVM: BaseVM{
    @Published var meals : [UserMeals] = []
    private let pc = PersistenceController.shared
    @Published var filteredMeals: [UserMeals] = []
    @Published var allMeals : [UserMeals] = []
    @Published var source: Source = .myIdeas
    @Published var tabData : [TabItem] = [TabItem(meals: [], tag: 1)]

    struct TabItem: Identifiable{
        var id = UUID()
        var meals : [UserMeals]
        var tag : Int
    }
// MARK: - get All Meals
    func getAllMeals(){
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        do {
            allMeals = try pc.container.viewContext.fetch(request)
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Reset Values
    
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        print("My Ideas Query: \(query), queryType: \(queryType.rawValue)")
        if originalQueryType != queryType ||
            allMeals.count != meals.count{
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

        tabData = [TabItem(meals: [], tag: 1)] // default back to blank when switching, without this we get index out of range since tabData has to have at least one tab
        switch queryType {
        case .random:
            print("My Ideas Random")
           
            meals = allMeals.shuffled()
            if meals.count == 0{
                noMealsFound = true
            }

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
            if meals.count == 0{
                noMealsFound = true
            }
            setupTabs()

            
        case .ingredient:
            print("My Ideas ingredients")
            for meal in allMeals{
                if let safeIngredients = meal.ingredients as? [String]{
                    if safeIngredients.contains(query){
                        meals.append(meal)
                    }
                }
            }

            if meals.count == 0{
                noMealsFound = true
            }
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

            if meals.count == 0{
                noMealsFound = true
            }
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
        print("Meals count before: \(meals.count)")
        if meals.count > 10 {
            //Takes the first 10 of the array and puts them on a new tab
            let tenMeals = Array(meals.prefix(10))
            let tabItem = TabItem(meals: tenMeals, tag: newTag)
            tabData.append(tabItem)
            meals.removeFirst(10)
        } else {
            if meals.count == 0{
                return
            }
            //Add remaining meals to the last page
            let tabItem = TabItem(meals: Array(meals), tag: newTag)
            tabData.append(tabItem)
            meals = []
        }
        print("Meals.count after: \(meals.count)")
        selectedTab = newTag
        
        if meals.count == 0{
            moreToShow = false
        } else {
            moreToShow = true
        }
    }
    
    // MARK: - Get More Meals
    func getMore(){
        getMoreMeals = false
        newTag += 1
        setupTabs()
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

