//
//  MealDBVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import Foundation
import CoreData
import SwiftUI

@MainActor final class MealDBVM: BaseVM{
    
    @Published var meals : [MealDBResults.Meal] = []
    @Published var source: Source = .mealDB
    @Published var surpriseMeal: MealDBResults.Meal?
    

    override func checkQuery(query: String, queryType: QueryType){
        print("MealDB Query: \(query), queryType: \(queryType.rawValue)")
        surpriseMealReady = false
        showWelcome = false
        if originalQueryType != queryType  {
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            getMealDBMeals(query: query, queryType: queryType)
        } else {
            if originalQuery != query {
                meals = []
                self.originalQuery = query
                getMealDBMeals(query: query, queryType: queryType)
            } else {
                //same choice was selected so nothing should happen except for random
                if queryType == .random{
                    getMealDBMeals(query: query, queryType: queryType)
                }
            }
        }
    }


    func getMealDBMeals(query: String, queryType: QueryType) {
        isLoading = true
        allResultsShown = false
        Task {
            do{
                switch queryType {
                case .random:
                    print("random")
                    let newMeal = try await NetworkManager.shared.mealDBQuery(query: "", queryType: .random)
                    if let first = newMeal.first{
                        surpriseMeal = first
                        surpriseMealReady = true
                        allResultsShown = false
                        withAnimation(Animation.easeIn.delay(1)){
                            meals.insert(first, at: 0)
                        }
                    }
                    
                    
                case .category:
                    print("Fetching MealDB Category: \(query)")
                    var modified = query.replacingOccurrences(of: " ", with: "%20")
                    if modified == "Side%20Dish"{
                        modified = "Side"
                    }
                    meals = try await NetworkManager.shared.mealDBQuery(query: modified, queryType: .category)
                    allResultsToggle()
                    
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "_")
                    
                    meals = try await NetworkManager.shared.mealDBQuery(query: modifiedIngredient,
                                                                        queryType: .ingredient)
                    allResultsToggle()

                    
                case .none:
                    ()
                    
                    
                case .keyword:
                    let modifiedKeyword = query.replacingOccurrences(of: " ", with: "%20")
                    meals = try await NetworkManager.shared.mealDBQuery(query: modifiedKeyword,
                                                                        queryType: .keyword)
                    allResultsToggle()
                    
                    
                case .custom:
                    () // custom has it's own function
                }
                isLoading = false
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
    

    func checkForFavorite(id: String?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.mealDBID == id}){
            return true
        } else {
            return false
        }
    }


    func checkForHistory(id: String?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.mealDBID == id}){
            return true
        } else {
            return false
        }
    }
    

    override func customFilter(keyword: String, category: String, ingredient: String){
        if keyword == "" &&
            category == "" &&
            ingredient == ""{
            //Nothing provided, return
            return
        }
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
            
            Task {
                do {
                    // MARK: - Just keyword provided
                    if keyword != "" &&
                        category == "" &&
                        ingredient == ""{
                        getMealDBMeals(query: keyword, queryType: .keyword)
                        
                    }
                    
                    // MARK: - Just Category provided
                    if keyword == "" &&
                        category != "" &&
                        ingredient == ""{
                        getMealDBMeals(query: category, queryType: .category)
                        
                    }
                    
                    // MARK: - Just ingredient provided
                    if keyword == "" &&
                        category == "" &&
                        ingredient != ""{
                        getMealDBMeals(query: ingredient, queryType: .ingredient)
                        
                    }
                    
                    // MARK: - Keyword and category
                    if keyword != "" &&
                        category != "" &&
                        ingredient == "" {
                        print("Fetching MealDB Category: \(category)")
                        var safeCategory = category.replacingOccurrences(of: " ", with: "%20")
                        if safeCategory == "Side%20Dish"{
                            safeCategory = "Side"
                        }
                        let catMeals = try await NetworkManager.shared.mealDBQuery(query: safeCategory, queryType: .category)
                        print("CatMeals count: \(catMeals.count)")
                        
                        for meal in catMeals{
                            if let safeName = meal.strMeal{
                                if safeName.containsIgnoringCase(find: keyword){
                                    meals.append(meal)
                                }
                            }
                        }
                        print("Meals count: \(meals.count)")
                        allResultsToggle()
                    }
                    
                    // MARK: - Keyword and ingredient
                    if keyword != "" &&
                        category == "" &&
                        ingredient != "" {
                        let modifiedIngredient = ingredient.replacingOccurrences(of: " ", with: "_")
                        
                        let ingMeals = try await NetworkManager.shared.mealDBQuery(query: modifiedIngredient,
                                                                                   queryType: .ingredient)
                        print("ingMeals count: \(ingMeals.count)")
                        for meal in ingMeals{
                            if let safeName = meal.strMeal{
                                if safeName.containsIgnoringCase(find: keyword){
                                    meals.append(meal)
                                }
                            }
                        }
                        print("meals count: \(meals.count)")
                        allResultsToggle()
                    }
                    
                    // MARK: - Category and ingredient
                    if keyword == "" &&
                        category != "" &&
                        ingredient != "" {
                        
                        print("Fetching MealDB Category: \(category)")
                        var safeCategory = category.replacingOccurrences(of: " ", with: "%20")
                        if safeCategory == "Side%20Dish"{
                            safeCategory = "Side"
                        }
                        let catMeals = try await NetworkManager.shared.mealDBQuery(query: safeCategory, queryType: .category)
                        print("CatMeals count: \(catMeals.count)")
                        
                        let modifiedIngredient = ingredient.replacingOccurrences(of: " ", with: "_")
                        
                        let ingMeals = try await NetworkManager.shared.mealDBQuery(query: modifiedIngredient,
                                                                                   queryType: .ingredient)
                        print("ingMeals count: \(ingMeals.count)")
                        
                        meals = catMeals.filter{ingMeals.contains($0)}
                        print("meals count: \(meals.count)")
                        allResultsToggle()
                    }
                    
                    // MARK: - All three provided
                    if keyword != "" &&
                        category != "" &&
                        ingredient != "" {
                        
                        print("Fetching MealDB Category: \(category)")
                        var safeCategory = category.replacingOccurrences(of: " ", with: "%20")
                        if safeCategory == "Side%20Dish"{
                            safeCategory = "Side"
                        }
                        let catMeals = try await NetworkManager.shared.mealDBQuery(query: safeCategory, queryType: .category)
                        print("CatMeals count: \(catMeals.count)")
                        
                        let modifiedIngredient = ingredient.replacingOccurrences(of: " ", with: "_")
                        
                        let ingMeals = try await NetworkManager.shared.mealDBQuery(query: modifiedIngredient,
                                                                                   queryType: .ingredient)
                        print("ingMeals count: \(ingMeals.count)")
                        
                        let filteredMeals = catMeals.filter{ingMeals.contains($0)}
                        print("filtered meals count: \(filteredMeals.count)")
                        
                        for meal in filteredMeals{
                            if let safeName = meal.strMeal{
                                if safeName.containsIgnoringCase(find: keyword){
                                    meals.append(meal)
                                }
                            }
                        }
                        print("meals count: \(meals.count)")
                        allResultsToggle()
                    }
                    
                    
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
        }else {
            // call same request again and add offset since user scrolled to get more results
        }
    }
    
    
    func stopLoading(){
        if isLoading{
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                if self.isLoading == true{
                    print("loading for 7.5 seconds, stopping and displaying alert")
                    self.isLoading = false
                }
            }
        }
    }
    
    
    func allResultsToggle(){
        if meals.isEmpty{
            allResultsShown = false // hide the alert
        } else {
            allResultsShown = true
        }
    }
    
    
    override func clearMeals() {
        self.meals = []
    }
}
