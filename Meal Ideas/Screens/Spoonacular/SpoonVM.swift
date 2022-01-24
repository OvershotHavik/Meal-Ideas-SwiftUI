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
//    @Published var keywordResults : [SpoonacularKeywordResults.result] = []
    @Published var individualMeal: SpoonacularResults.Recipe?
    @Published var source: Source = .spoonacular
    @Published var surpriseMeal: SpoonacularResults.Recipe?
    
    // MARK: - Check Query
    func checkQuery(query: String, queryType: QueryType){
        print("Spoon query: \(query) Type: \(queryType.rawValue)")

        if isLoading == true {
            return
        }
        surpriseMealReady = false
        showWelcome = false

        if originalQueryType != queryType {
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            getSpoonMeals(query: query, queryType: queryType)
        } else {
            if originalQuery != query{
                meals = []
                self.originalQuery = query
                getSpoonMeals(query: query, queryType: queryType)
            } else {
                
                if queryType == .random{
                    getSpoonMeals(query: query, queryType: queryType)
                    return
                }
                offsetBy += 10
                getSpoonMeals(query: query, queryType: queryType)
                

            }
        }
    }
    
    
    // MARK: - Get Spoon Meals
    func getSpoonMeals(query: String, queryType: QueryType){
        isLoading = true
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
                        }
//                        meals.insert(first, at: 0)
                    }
//                    meals.append(contentsOf: randomMeals)
                    
//                    if offsetBy == 0{
//                        if meals.count < 10{
//                            moreToShow = false
//                        } else {
//                            moreToShow = true
//                        }
//
//                    } else {
//                        if meals.count < offsetBy{
//                            moreToShow = false
//                        } else {
//                            moreToShow = true
//                        }
//                    }

                    
                case .category:
                    let modifiedCategory = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    print(modifiedCategory)
                    let modified = modifiedCategory.lowercased() + "&offset=\(offsetBy)"

                    let catMeals = try await NetworkManager.shared
                        .spoonComplexQuery(query: modified, queryType: .category)
                    meals.append(contentsOf: catMeals.results)
                    if let safeTotalResults = catMeals.totalResults{
                        totalMealCount = safeTotalResults
                    }
                    

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
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                    let modified = modifiedIngredient.lowercased() + "&offset=\(offsetBy)"
                    let ingMeals = try await NetworkManager.shared.spoonComplexQuery(query: modified, queryType: .ingredient)
                    meals.append(contentsOf: ingMeals.results)
                    if let safeTotalResults = ingMeals.totalResults{
                        totalMealCount = safeTotalResults
                    }
                    
                    print("ingredient")
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
                case .keyword:
                    var safeKeyword = query.lowercased()
                    safeKeyword = safeKeyword.replacingOccurrences(of: " ", with: "%20")
                    print(safeKeyword)
                    print("keyword Offset: \(offsetBy)")
                    let modified = safeKeyword + "&offset=\(offsetBy)"
                    let keywordMeals = try await NetworkManager.shared.spoonComplexQuery(query: modified, queryType: .keyword)
                    meals.append(contentsOf: keywordMeals.results)
                    if let safeTotalResults = keywordMeals.totalResults{
                        totalMealCount = safeTotalResults
                    }
                    print("spoon keyword meals count: \(meals.count)")
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

                    
                case .none:
                    let meal = try await NetworkManager.shared.spoonQuery(query: query, queryType: .none)
                    if let safeMeal = meal.first{
                        individualMeal = safeMeal
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
            }
        }
    }

    // MARK: - Get Meal From ID
    func getMealFromID(mealID: Int) async -> SpoonacularResults.Recipe?{
        
        getSpoonMeals(query: "\(mealID)", queryType: .none)
        if let safeMeal = individualMeal{
            return safeMeal
        }
        return nil
    }
    

    // MARK: - Check For History
    func checkForHistory(id: Int?, historyArray: [History]) -> Bool{
        if historyArray.contains(where: {$0.spoonID == Double(id ?? 0)}){
//            print("History meal id: \(id ?? 0)")
            return true
        } else {
            return false
        }
    }
    // MARK: - Check For Favorite
    func checkForFavorite(id: Int?, favoriteArray: [Favorites]) -> Bool{
        if favoriteArray.contains(where: {$0.spoonID == Double(id ?? 0)}){
//            print("favorited meal id: \(id ?? 0)")
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Fetch Plsit for category verification
//    func fetchPlist(plist: PList){
//        if sourceCategories.isEmpty{
//            PListManager.loadItemsFromLocalPlist(XcodePlist: plist,
//                                                 classToDecodeTo: [NewItem].self,
//                                                 completionHandler: { [weak self] result in
//                if let self = self {
//                    switch result {
//                    case .success(let itemArray):
//                        self.sourceCategories = itemArray.map{$0.itemName}
//                    case .failure(let e): print(e)
//                    }
//                }
//            })
//        }
//    }
}
//@objc private func post(_ sender: UIButton) {
//    Task {
//        // defer { dismiss(animated: true) } -- Doesn't work
//        defer { Task { await dismiss(animated: true) } }
//        do {
//            try await doSomethingAsync()
//        } catch {
//            print(error)
//        }
//    }
//}
