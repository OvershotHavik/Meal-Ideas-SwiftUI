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
    @Published var surpriseMeal : UserMeals?
    

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
        print("My Ideas Query: \(query), queryType: \(queryType.rawValue)")
        if originalQueryType != queryType {
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
        switch queryType {
        case .random:
            print("My Ideas Random")
            let shuffled = allMeals.shuffled()
            if let first = shuffled.first{
                surpriseMeal = first
                meals.append(first)
            }
//            meals = allMeals.shuffled()
//            allResultsShown = true
//            totalMealCount = meals.count

        case .category:
            print("My Ideas category")
            for meal in allMeals{
                if let safeCategories = meal.category as? [String]{
                    if safeCategories.contains(query){
                        meals.append(meal)
                        allResultsShown = true
                    }
                }
            }
            totalMealCount = meals.count

            
        case .ingredient:
            print("My Ideas ingredients")
            for meal in allMeals{
                if let safeIngredients = meal.ingredients as? [String]{
                    if safeIngredients.contains(query){
                        meals.append(meal)
                        allResultsShown = true
                    }
                }
            }
            totalMealCount = meals.count

            
        case .keyword:
            print("My Ideas keyword")
            for meal in allMeals{
                if let safeName = meal.mealName{
                    if safeName.containsIgnoringCase(find: query){
                        print("meal matches query: \(meal.mealName ?? "")")
                        meals.append(meal)
                        allResultsShown = true
                    }
                }
            }
            totalMealCount = meals.count

        case .none:
            print("My Ideas none")
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

