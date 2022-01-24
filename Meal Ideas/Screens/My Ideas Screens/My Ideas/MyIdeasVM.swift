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
    
    
    // TODO:  Add a category verification to user meals so that the category list only shows what the user has created meals for
    // TODO:  Add

    init(){
        super.init(sourceCategory: .categories)
        getAllMeals()
    }
// MARK: - get All Meals
    func getAllMeals(){
        //used to get all meals, runs on on appear of the view, and if all meals changes, goes through check query
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        do {
            allMeals = try pc.container.viewContext.fetch(request)

            for meal in allMeals{
                userCategories.append(contentsOf: meal.category as? [String] ?? [])
                userIngredients.append(contentsOf: meal.ingredients as? [String] ?? [])
            }
            
            userCategories = userCategories.unique()
            userIngredients = userIngredients.unique()
            print(userCategories)
            print(userIngredients)

        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
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
    func customFilter(keyword: String?, category: String?, ingredient: String?){
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
            print("Keyword: \(keyword ?? ""), category: \(category ?? ""), ingredient: \(ingredient ?? "")")
            
            
            var filteredKeyword : [UserMeals] = []
            var filteredCategory: [UserMeals] = []
            var filteredIngredients: [UserMeals] = []

            for meal in allMeals{
                if let safeName = meal.mealName{
                    if let safeKeyword = keyword{
                        if safeName.containsIgnoringCase(find: safeKeyword){
                            print("meal matches Name: \(meal.mealName ?? "")")
                            filteredKeyword.append(meal)
                        }
                    }
                }
                if let safeCategories = meal.category as? [String]{
                    if let safeCat = category{
                        if safeCategories.contains(safeCat){
                                //add to the array
                            print("meal matched category \(meal.mealName ?? "")")
                            filteredCategory.append(meal)
                            
                        }
                    }
                }

                
                if let safeIngredients = meal.ingredients as? [String]{
                    if let safeIng = ingredient{
                        if safeIngredients.contains(safeIng){
                                //add to the array
                                print("meal matched ingredient: \(meal.mealName ?? "")")
                            filteredIngredients.append(meal)
                        }
                    }
                }
        
            }
            print("Filtered keyword count: \(filteredKeyword.count)")
            print("Filtered category count: \(filteredCategory.count)")
            print("filtered ingredient count: \(filteredIngredients.count)")
           

            // just keyword results
            if !filteredKeyword.isEmpty &&
                filteredCategory.isEmpty &&
                filteredIngredients.isEmpty{
                meals = filteredKeyword
                return
            }
            
            // just category results
            if filteredKeyword.isEmpty &&
                !filteredCategory.isEmpty &&
                filteredIngredients.isEmpty{
                meals = filteredCategory
                return
            }
            // just ingredient results
            if filteredKeyword.isEmpty &&
                filteredCategory.isEmpty &&
                !filteredIngredients.isEmpty{
                meals = filteredIngredients
                return
            }
            
            // keyword and category filter
            if !filteredKeyword.isEmpty &&
                !filteredCategory.isEmpty &&
                filteredIngredients.isEmpty{
                meals = filteredKeyword.filter{filteredCategory.contains($0)}
                return
            }
            
            // keyword and ingredient filter
            if !filteredKeyword.isEmpty &&
                filteredCategory.isEmpty &&
                !filteredIngredients.isEmpty{
                meals = filteredKeyword.filter{filteredIngredients.contains($0)}
                return
            }
            
            // keyword and ingredient filter
            if !filteredKeyword.isEmpty &&
                filteredCategory.isEmpty &&
                !filteredIngredients.isEmpty{
                meals = filteredKeyword.filter{filteredIngredients.contains($0)}
                return
            }
            
            // ingredient and category filter
            if filteredKeyword.isEmpty &&
                !filteredCategory.isEmpty &&
                !filteredIngredients.isEmpty{
                meals = filteredCategory.filter{filteredIngredients.contains($0)}
                return
            }
            
            // all three have results
            if !filteredKeyword.isEmpty &&
                !filteredCategory.isEmpty &&
                !filteredIngredients.isEmpty{
                let keyCat = filteredKeyword.filter{filteredCategory.contains($0)}
                meals = filteredIngredients.filter{keyCat.contains($0)}
                return
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

