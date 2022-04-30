//
//  MealDBVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import CoreData
import SwiftUI
import Combine

@MainActor final class MealDBVM: BaseVM{
    
    @Published var meals : [MealDBResults.Meal] = []
    @Published var surpriseMeal: MealDBResults.Meal?
    var cancellables = Set<AnyCancellable>()
    
    init(){
        super.init(sourceCategory: .mealDBCategories, source: .mealDB)
//        setupMealPublisher()
    }
    
    func setupMealPublisher(){
        $meals
            .sink { [weak self] _ in
                self?.allResultsToggle()
            }
            .store(in: &cancellables)
    }


    override func checkQuery(query: String, queryType: QueryType, completed: @escaping () -> Void){
        print("MealDB Query: \(query), queryType: \(queryType.rawValue)")
        surpriseMealReady = false
        showWelcome = false
        if originalQueryType != queryType  {
            meals = []
            self.originalQueryType = queryType
            self.originalQuery = query
            getMealDBMeals(query: query, queryType: queryType){
                completed()
            }
        } else {
            if originalQuery != query {
                meals = []
                self.originalQuery = query
                getMealDBMeals(query: query, queryType: queryType){
                    completed()
                }
            } else {
                //same choice was selected so nothing should happen except for random
                if queryType == .random{
                    getMealDBMeals(query: query, queryType: queryType){
                        completed()
                    }
                }
            }
        }
    }
    
    
    func setupSurpriseMealPublisher(){
//        $surpriseMeal
            
    }
    


    func getMealDBMeals(query: String, queryType: QueryType, completed: @escaping () -> Void) {
        isLoading = true
        allResultsShown = false
        Task {
            do{
                switch queryType {
                case .random:
                    print("random")
                    guard let url = URL(string: BaseURL.mealDBRandom) else {
                        throw MIError.invalidURL
                    }
                    print(url)
                    getRandomMeals(url: url){
                        completed()
                    }
                    
                case .category:
                    var modified = query.replacingOccurrences(of: " ", with: "%20")
                    if modified == "Side%20Dish"{
                        modified = "Side"
                    }
                    guard let url = URL(string: BaseURL.mealDBCategories + modified) else {
                        throw MIError.invalidURL
                    }
                    print(url)
                    getMeals(url: url){
                        completed()
                    }
                    
                case .ingredient:
                    let modifiedIngredient = query.replacingOccurrences(of: " ", with: "_")
                    
                    guard let url = URL(string: BaseURL.mealDBIngredient + modifiedIngredient) else {
                        throw MIError.invalidURL
                    }
                    print(url)
                    getMeals(url: url){
                        completed()
                    }

                    
                case .none:
                    ()
                    
                    
                case .keyword:
                    let modifiedKeyword = query.replacingOccurrences(of: " ", with: "%20")
                    guard let url = URL(string: BaseURL.mealDBKeyword + modifiedKeyword) else {
                        throw MIError.invalidURL
                    }
                    print(url)
                    getMeals(url: url){
                        completed()
                    }
                    
                    
                case .custom:
                    () // custom has it's own function
                }
            }catch{
                if meals.count == 0{
                    meals = [] // for testing to pass correctly
//                    completed()
                }
                if let miError = error as? MIError{
                    switch miError {
                        //only ones that would come through should be invalidURL or invalid data, but wanted to keep the other cases
                    case .invalidURL:
                        alertItem = AlertContext.invalidURL
                    case .invalidData:
                        alertItem = AlertContext.invalidData
//                        completed()
                    default: alertItem = AlertContext.invalidResponse // generic error if wanted..
                    }
//                    completed()
                } else {
                    alertItem = AlertContext.invalidResponse // generic error would go here
                    isLoading = false
                }
                completed()
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
    

    override func customFilter(keyword: String, category: String, ingredient: String, completed: @escaping () -> Void){
        if keyword == "" &&
            category == "" &&
            ingredient == ""{
            //Nothing provided, return
            completed()
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
                        getMealDBMeals(query: keyword, queryType: .keyword){
                            completed()
                        }
                    }
                    
                    // MARK: - Just Category provided
                    if keyword == "" &&
                        category != "" &&
                        ingredient == ""{
                        getMealDBMeals(query: category, queryType: .category){
                            completed()
                        }
                    }
                    
                    // MARK: - Just ingredient provided
                    if keyword == "" &&
                        category == "" &&
                        ingredient != ""{
                        getMealDBMeals(query: ingredient, queryType: .ingredient){
                            completed()
                        }
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
                        
//                        meals = catMeals.filter({(($0.strMeal?.containsIgnoringCase(find: keyword)) != nil)})
                        for meal in catMeals{
                            if let safeName = meal.strMeal{
                                if safeName.containsIgnoringCase(find: keyword){
                                    meals.append(meal)
                                }
                            }
                        }
                        print("Meals count: \(meals.count)")
                        allResultsToggle()
                        completed()
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
                        completed()
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
                        completed()
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
                        completed()
                    }
                    
                    
                } catch {
                    if meals.count == 0{
                        meals = [] // for testing to pass correctly
                    }
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
        }
    }
    
    
    private func allResultsToggle(){
        if meals.isEmpty{
            allResultsShown = false // hide the alert
        } else {
            allResultsShown = true
        }
    }
    
    
    override func clearMeals() {
        self.meals = []
    }
    
    
    private func getRandomMeals(url: URL, completed: @escaping () -> Void){
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: MealDBResults.Results.self, decoder: JSONDecoder())
            .sink {[weak self] completion in
                guard let self = self else {return}
                switch completion{
                case .finished:
                    print("finished!")
                case .failure(let error):
                    self.alertItem = AlertContext.invalidData
                    print("Error: \(error.localizedDescription)") // show an alert here based on the error in a real app
                    completed()
                }
            } receiveValue: {[weak self] returnedMeals in
                guard let self = self else {return}
                let results = returnedMeals.meals
                if let first = results.first{
                    self.surpriseMeal = first
                    self.surpriseMealReady = true
                    self.isLoading = false
                    self.allResultsShown = false
                    withAnimation(Animation.easeIn.delay(1)){
                        self.meals.insert(first, at: 0)
                    }
                    completed()
                }
            }
            .store(in: &cancellables)
    }

    
    private func getMeals(url: URL, completed: @escaping () -> Void){
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: MealDBResults.Results.self, decoder: JSONDecoder())
            .sink{ [weak self] completion in
                guard let self = self else {return}
                switch completion{
                case .finished:
                    print("finished!")
                case .failure(let error):
                    self.alertItem = AlertContext.invalidData
                    print("Error: \(error.localizedDescription)") // show an alert here based on the error in a real app
                    completed()
                }
                
            } receiveValue: { [weak self] returnedMeals in
                guard let self = self else {return}
                self.meals = returnedMeals.meals
                self.isLoading = false
                self.allResultsToggle()
                completed()
            }
            .store(in: &cancellables)
    }
    
    
    func cancelTasks(){
        for item in self.cancellables{
            item.cancel()
        }
    }
}
