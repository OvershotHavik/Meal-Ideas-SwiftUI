//
//  SpoonVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI
import CoreData

@MainActor final class SpoonVM: BaseVM{
    @Published var meals: [SpoonacularResults.Recipe] = []
    @Published var individualMeal: SpoonacularResults.Recipe?
    @Published var surpriseMeal: SpoonacularResults.Recipe?
    @Published var customURLString = ""

    override func checkQuery(query: String, queryType: QueryType, completed: @escaping () -> Void){
        print("Spoon query: \(query) Type: \(queryType.rawValue)")
        
        if isLoading == true {
            return
        }
        surpriseMealReady = false
        showWelcome = false
        
        if originalQueryType != queryType {
            offsetBy = 0
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            getSpoonMeals(query: query, queryType: queryType){
                completed()
            }
        } else {
            if originalQuery != query{
                offsetBy = 0
                meals = []
                self.originalQuery = query
                getSpoonMeals(query: query, queryType: queryType){
                    completed()
                }
            } else {
                
                if queryType == .random{
                    getSpoonMeals(query: query, queryType: queryType){
                        completed()
                    }
                    return
                }
                offsetBy += 10
                getSpoonMeals(query: query, queryType: queryType){
                    completed()
                }
            }
        }
    }
    
    
    private func getSpoonMeals(query: String, queryType: QueryType, completed: @escaping () -> Void){
        isLoading = true
        totalMealCount = 0
        Task {
            do {
                switch queryType{
                case .random:
                    let randomMeals = try await NetworkManager.shared.spoonQuery(query: query, queryType: queryType)
                    if let first = randomMeals.first{
                        surpriseMeal = first
                        surpriseMealReady = true
                        allResultsShown = false
                        withAnimation(Animation.easeIn.delay(1)){
                            meals.insert(first, at: 0)
                            completed()
                        }
                    }
                    
                    
                case .category:
                    let modifiedCategory = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    print(modifiedCategory)
                    let modified = modifiedCategory + "&offset=\(offsetBy)"
                    let catMeals = try await NetworkManager.shared.spoonComplexQuery(query: modified, queryType: .category)
                    addResultsToMeals(mealsToAdd: catMeals)
                    completed()
                    
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    let modified = modifiedIngredient + "&offset=\(offsetBy)"
                    let ingMeals = try await NetworkManager.shared.spoonComplexQuery(query: modified, queryType: .ingredient)
                    addResultsToMeals(mealsToAdd: ingMeals)
                    completed()
                    
                    
                case .keyword:
                    let safeKeyword = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    print(safeKeyword)
                    print("keyword Offset: \(offsetBy)")
                    let modified = safeKeyword + "&offset=\(offsetBy)"
                    let keywordMeals = try await NetworkManager.shared.spoonComplexQuery(query: modified, queryType: .keyword)
                    addResultsToMeals(mealsToAdd: keywordMeals)
                    completed()
                    
                    
                case .none:
                    let meal = try await NetworkManager.shared.spoonQuery(query: query, queryType: .none)
                    if let safeMeal = meal.first{
                        individualMeal = safeMeal
                        completed()
                    }
                    
                case .custom:
                    print("Custom not setup yet in spoonVM")
                }
                
                isLoading = false
                print("More to show: \(moreToShow)")
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
                completed()
            }
        }
    }
    
    
    private func addResultsToMeals(mealsToAdd: SpoonacularResults.ResultsFromComplex){
        self.meals.append(contentsOf: mealsToAdd.results)
        if let safeTotalResults = mealsToAdd.totalResults{
            totalMealCount = safeTotalResults
        }
        determineMoreToShow()
    }

    
    override func customFilter(keyword: String, category: String, ingredient: String, completed: @escaping () -> Void){
        if keyword == "" &&
            category == "" &&
            ingredient == ""{
            //Nothing provided, return
            completed()
            return
        }
        if isLoading == true {
            return
        }
        isLoading = true
        showWelcome = false
        allResultsShown = false
        surpriseMealReady = false
        
        if originalCustomKeyword == keyword &&
            originalCustomCategory == category &&
            originalCustomIngredient == ingredient{
            //nothing changed
            isLoading = false
            return
        }

        if originalCustomKeyword != keyword ||
            originalCustomCategory != category ||
            originalCustomIngredient != ingredient{
            totalMealCount = 0
            meals = []
            customURLString = ""
            self.originalCustomKeyword = keyword
            self.originalCustomCategory = category
            self.originalCustomIngredient = ingredient
            print("Keyword: \(keyword), category: \(category), ingredient: \(ingredient)")
            
            Task {
                
                do {
                    if keyword != ""{
                        print("Keyword provided: \(keyword)")
                        let modifiedKeyword = keyword.replacingOccurrences(of: " ", with: "%20").lowercased()
                        print(modifiedKeyword)
                        let keywordString = SpoonTags.keyword.rawValue + modifiedKeyword
                        customURLString += keywordString
                    }
                    
                    if category != "" {
                        print("Category provided: \(category)")
                        let modifiedCategory = category.replacingOccurrences(of: " ", with: "%20").lowercased()
                        print(modifiedCategory)
                        
                        let categoryString = SpoonTags.category.rawValue + modifiedCategory
                        customURLString += categoryString
                    }
                    
                    if ingredient != ""{
                        print("Ingredient provided: \(ingredient)")
                        let modifiedIngredient = ingredient.replacingOccurrences(of: " ", with: "%20").lowercased()
                        let ingredientString = SpoonTags.ingredient.rawValue + modifiedIngredient
                        customURLString += ingredientString
                        
                    }
                    
                    if customURLString == ""{
                        return // nothing was provided, and if we do a search it will just bring back random which doesn't look good
                    }
                    let query = customURLString + "&offset=\(offsetBy)"
                    let customMeals = try await NetworkManager.shared.spoonComplexQuery(query: query , queryType: .custom)
                    addResultsToMeals(mealsToAdd: customMeals)
                    isLoading = false
                    completed()
                    
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
                    completed()
                }
            }
            
        }else {
            // call same request again and add offset since user scrolled to get more results
            Task{
                do{
                    print("Load more meals")
                    offsetBy += 10
                    let query = customURLString + "&offset=\(offsetBy)"
                    
                    let customMeals = try await NetworkManager.shared.spoonComplexQuery(query: query, queryType: .custom)
                    meals.append(contentsOf: customMeals.results)
                    if let safeTotalResults = customMeals.totalResults{
                        totalMealCount = safeTotalResults
                    }
                    
                    print("spoon custom meals count: \(meals.count)")
                    determineMoreToShow()
                    isLoading = false
                    completed()
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
                    completed()
                }
            }
        }
    }


    private func determineMoreToShow(){
        if offsetBy == 0{
            if meals.count < 10{
                moreToShow = false
            } else {
                moreToShow = true
            }
            
        } else {
            if meals.count < offsetBy{
                moreToShow = false
            } else {
                moreToShow = true
            }
        }
    }
        
    
    func checkForHistory(id: Int?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.spoonID == Double(id ?? 0)}){
            return true
        } else {
            return false
        }
    }


    func checkForFavorite(id: Int?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.spoonID == Double(id ?? 0)}){
            return true
        } else {
            return false
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
    
    
    override func clearMeals() {
        self.meals = []
    }
}
