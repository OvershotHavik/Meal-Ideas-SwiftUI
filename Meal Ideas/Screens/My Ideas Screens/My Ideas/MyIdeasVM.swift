//
//  MyIdeasVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI
import CoreData

final class MyIdeasVM: ObservableObject{
    @Published var meals : [UserMeals] = []
    private let pc = PersistenceController.shared
    @Published var filteredMeals: [UserMeals] = []
    @Published var originalQueryType = QueryType.none
    @Published var isLoading = false
    @Published var originalQuery: String?
    @Published var keywordSearchTapped = false
    @Published var getMoreMeals = false
    
    init(){
    }

    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        print("My Ideas Query: \(query), queryType: \(queryType.rawValue)")
        // TODO:  Add a check in here to add to the array if the query and query type haven't changed, but also make sure there are unique items still
        if originalQueryType != queryType{
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
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        var allMeals : [UserMeals] = []
        do {
            allMeals = try pc.container.viewContext.fetch(request)
            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
        
        switch queryType {
        case .random:
            print("My Ideas Random")
            meals = allMeals
        case .category:
            print("My Ideas category")
            for meal in allMeals{
                if let safeCategories = meal.category as? [String]{
                    if safeCategories.contains(query){
                        meals.append(meal)
                    }
                }
            }
            
            
        case .ingredient:
            print("My Ideas ingredients")
            for meal in allMeals{
                if let safeIngredients = meal.ingredients as? [String]{
                    if safeIngredients.contains(query){
                        meals.append(meal)
                    }
                }
            }
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

            
            
        case .history:
            print("My Ideas History")
        case .favorite:
            print("My Ideas Favorite")
        case .none:
            print("My Ideas none")
        }
    }


}

