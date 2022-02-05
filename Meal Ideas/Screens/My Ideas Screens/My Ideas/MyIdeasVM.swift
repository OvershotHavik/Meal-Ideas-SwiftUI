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
    @Published var allMeals : [UserMeals] = []
    @Published var source: Source = .myIdeas
    @Published var surpriseMeal : UserMeals?
    @Published var userCategories : [String] = []
    @Published var userIngredients: [String] = []
    
    
    init(){
        super.init(sourceCategory: .categories)
        getAllMeals()
    }
    // MARK: - get All Meals
    func getAllMeals(){
        //used to get all meals, runs on on appear of the view, and if all meals changes, goes through check query
        let request = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
        do {
            userCategories = []
            userIngredients = []
            allMeals = try pc.container.viewContext.fetch(request)
            
            for meal in allMeals{
                userCategories.append(contentsOf: meal.category as? [String] ?? [])
                userIngredients.append(contentsOf: meal.ingredients as? [String] ?? [])
            }
            
            userCategories = userCategories.unique()
            userIngredients = userIngredients.unique()
            if userIngredients.isEmpty{
                userIngredients.append(Messages.noIngredient.rawValue)
            }
            
            
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Show All Meals
    func showAllMeals(){
        showWelcome = false
        allResultsShown  = false
        surpriseMealReady = false
        
        meals = allMeals
        allResultsShown = true
    }
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        if allMeals.isEmpty{
            alertItem = AlertContext.noMeals
            return
        }
        print("My Ideas Query: \(query), queryType: \(queryType.rawValue)")
        showWelcome = false
        allResultsShown  = false
        surpriseMealReady = false
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
                if queryType == .random{
                    filterMeals(query: query, queryType: queryType)
                }
            }
        }
    }
    
    // MARK: - Custom Filter
    func customFilter(keyword: String, category: String, ingredient: String){
        showWelcome = false
        allResultsShown = false
        surpriseMealReady = false
        
        if originalCustomKeyword != keyword ||
            originalCustomCategory != category ||
            originalCustomIngredient != ingredient{
            meals = []
            self.originalCustomKeyword = keyword
            self.originalCustomCategory = category
            self.originalCustomIngredient = ingredient
            print("Keyword: \(keyword), category: \(category), ingredient: \(ingredient)")
            
            
            // MARK: - Just keyword provided
            if keyword != "" &&
                category == "" &&
                ingredient == ""{
                filterMeals(query: keyword, queryType: .keyword)
            }
            
            // MARK: - Just Category provided
            if keyword == "" &&
                category != "" &&
                ingredient == ""{
                filterMeals(query: category, queryType: .category)
            }
            
            // MARK: - Just ingredient provided
            if keyword == "" &&
                category == "" &&
                ingredient != ""{
                filterMeals(query: ingredient, queryType: .ingredient)
            }
            // MARK: - Keyword and category
            if keyword != "" &&
                category != "" &&
                ingredient == "" {
                
                for meal in allMeals{
                    if let safeCategories = meal.category as? [String]{
                        if safeCategories.contains(category){
                            if let safeName = meal.mealName{
                                if safeName.containsIgnoringCase(find: keyword){
                                    print("meal matches cat and keyword: \(meal.mealName ?? "")")
                                    meals.append(meal)
                                }
                            }
                        }
                    }
                }
                print("Meals count: \(meals.count)")
            }
            // MARK: - Keyword and ingredient
            if keyword != "" &&
                category == "" &&
                ingredient != "" {
                for meal in allMeals{
                    if let safeIngredients = meal.ingredients as? [String]{
                        if safeIngredients.contains(ingredient){
                            if let safeName = meal.mealName{
                                if safeName.containsIgnoringCase(find: keyword){
                                    print("meal matches ingredient and keyword: \(meal.mealName ?? "")")
                                    meals.append(meal)
                                }
                            }
                        }
                    }
                }
                print("Meals count: \(meals.count)")
            }
            
            // MARK: - Category and ingredient
            if keyword == "" &&
                category != "" &&
                ingredient != "" {
                for meal in allMeals{
                    if let safeCategories = meal.category as? [String],
                       let safeIngredients = meal.ingredients as? [String]{
                        if safeCategories.contains(category){
                            if safeIngredients.contains(ingredient){
                                print("meal matches ingredient and category: \(meal.mealName ?? "")")
                                meals.append(meal)
                            }
                        }
                    }
                }
                print("Meals count: \(meals.count)")
            }
            
            // MARK: - All three provided
            if keyword != "" &&
                category != "" &&
                ingredient != "" {
                for meal in allMeals{
                    if let safeCategories = meal.category as? [String],
                       let safeIngredients = meal.ingredients as? [String]{
                        if safeCategories.contains(category){
                            if safeIngredients.contains(ingredient){
                                if let safeName = meal.mealName{
                                    if safeName.containsIgnoringCase(find: keyword){
                                        print("meal matches all three: \(meal.mealName ?? "")")
                                        meals.append(meal)
                                    }
                                }
                            }
                        }
                    }
                }
                print("Meals count: \(meals.count)")
            }
        }
    }
    // MARK: - Filter Meals
    func filterMeals(query: String, queryType: QueryType){
        // TODO:  Animate the meals leaving and coming in
        getAllMeals()
        isLoading = true
        
        switch queryType {
        case .random:
            print("My Ideas Random")
            let shuffled = allMeals.shuffled()
            if let first = shuffled.first{
                surpriseMeal = first
                surpriseMealReady = true
                withAnimation(Animation.easeIn.delay(1)){
                    isLoading = false
                    meals.insert(first, at: 0)
                    meals = meals.unique()
                }
            }
            
            
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
            
            
        case .custom:
            print("Custom not setup yet in my ideas")
        case .none:
            print("My Ideas none")
        }
        isLoading = false
    }
    
    // MARK: - Check For Favorite
    func checkForFavorite(id: UUID?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.userMealID == id} ){
            return true
        } else {
            return false
        }
    }
    // MARK: - Check For History
    func checkForHistory(id: UUID?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.userMealID == id} ){
            return true
        } else {
            return false
        }
    }
}

