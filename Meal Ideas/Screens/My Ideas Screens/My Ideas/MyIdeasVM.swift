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
    @Published var surpriseMeal : UserMeals?
    @Published var userCategories : [String] = []
    @Published var userIngredients: [String] = []
    
    
    init(){
        super.init(sourceCategory: .categories, source: .myIdeas)
        getAllMeals()
    }


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
    

    func showAllMeals(){
        print("Show all meals")
        showWelcome = false
        allResultsShown  = false
        surpriseMealReady = false
        isLoading = true
        meals = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [ weak self]  in
            self?.meals = self?.allMeals ?? []
            self?.allResultsShown = true
            self?.isLoading = false
        })
    }
    

    override func checkQuery(query: String, queryType: QueryType){
        if allMeals.isEmpty{
            alertItem = AlertContext.noMeals
            return
        }
        print("My Ideas Query: \(query), queryType: \(queryType.rawValue)")
        showWelcome = false
        allResultsShown  = false
        surpriseMealReady = false
        isLoading = true
        
        if originalQueryType != queryType {
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            if originalQueryType == .random{
                //due to the way the random works, the delay brings back a nil value and messes it up, so need to skip the delay
                filterMeals(query: query, queryType: queryType)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [ weak self]  in
                    self?.filterMeals(query: query, queryType: queryType)
                })
            }
        } else {
            if originalQuery != query{
                meals = []
                self.originalQuery = query
                //                filterMeals(query: query, queryType: queryType)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [ weak self]  in
                    self?.filterMeals(query: query, queryType: queryType)
                })
            } else {
                // nothing happens, query and query type didn't change
                if queryType == .random{
                    filterMeals(query: query, queryType: queryType)
                }
                isLoading = false
            }
        }
    }
    

    override func customFilter(keyword: String, category: String, ingredient: String){
        if keyword == "" &&
            category == "" &&
            ingredient == ""{
            print("nothing provided for custom")
            //nothing provided
            return
        }
        
        if originalCustomKeyword != keyword ||
            originalCustomCategory != category ||
            originalCustomIngredient != ingredient{
            meals = []
            self.originalCustomKeyword = keyword
            self.originalCustomCategory = category
            self.originalCustomIngredient = ingredient
            print("Keyword: \(keyword), category: \(category), ingredient: \(ingredient)")
            isLoading = true
            showWelcome = false
            allResultsShown = false
            surpriseMealReady = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [ weak self]  in
                guard let allMeals = self?.allMeals else {return}
                
                // MARK: - Just keyword provided
                if keyword != "" &&
                    category == "" &&
                    ingredient == ""{
                    self?.filterMeals(query: keyword, queryType: .keyword)
                }
                
                // MARK: - Just Category provided
                if keyword == "" &&
                    category != "" &&
                    ingredient == ""{
                    self?.filterMeals(query: category, queryType: .category)
                }
                
                // MARK: - Just ingredient provided
                if keyword == "" &&
                    category == "" &&
                    ingredient != ""{
                    self?.filterMeals(query: ingredient, queryType: .ingredient)
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
                                        self?.meals.append(meal)
                                    }
                                }
                            }
                        }
                    }
                    print("Meals count: \(self?.meals.count ?? 0)")
                    self?.isLoading = false
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
                                        self?.meals.append(meal)
                                    }
                                }
                            }
                        }
                    }
                    print("Meals count: \(self?.meals.count ?? 0)")
                    self?.isLoading = false
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
                                    self?.meals.append(meal)
                                }
                            }
                        }
                    }
                    print("Meals count: \(self?.meals.count ?? 0)")
                    self?.isLoading = false
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
                                            self?.meals.append(meal)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    print("Meals count: \(self?.meals.count ?? 0)")
                    self?.isLoading = false
                }
            })
        }
        if meals.count == 0{
            meals = [] // for tests, it needs to publish for the test to complete correctly
        }
    }


    func filterMeals(query: String, queryType: QueryType){
        getAllMeals()
        isLoading = true
        
        switch queryType {
        case .random:
            print("My Ideas Random")
            let shuffled = allMeals.shuffled()
            if let first = shuffled.first{
                surpriseMeal = first
                surpriseMealReady = true
                withAnimation(.easeIn(duration: 1)){
                    meals.insert(first, at: 0)
                    meals = meals.unique()
                    isLoading = false
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
            print("custom has it's own function")
        case .none:
            print("My Ideas none")
        }
        
        if meals.count == 0{
            meals = [] // for tests, it needs to publish for the test to complete correctly
        }
        isLoading = false
    }
    

    func checkForFavorite(id: UUID?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.userMealID == id} ){
            return true
        } else {
            return false
        }
    }


    func checkForHistory(id: UUID?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.userMealID == id} ){
            return true
        } else {
            return false
        }
    }
    
    
    override func clearMeals() {
        self.meals = []
    }
}

