//
//  MealDBVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import Foundation

@MainActor final class MealDBVM: ObservableObject{
    @Published var meals : [MealDBResults.Meal] = []
    @Published var alertItem : AlertItem?
    @Published var isLoading = false
    @Published var originalQueryType = QueryType.none
    
    func checkQuery(query: String, queryType: QueryType){
        
        if originalQueryType != queryType{
            meals = []
            getMealDBMeals(query: query, queryType: queryType)
            self.originalQueryType = queryType
        } else {
            //do nothing since it hasn't changed
        }
    }
    // MARK: - Get MealDBMeals
    
    func getMealDBMeals(query: String, queryType: QueryType) {
        
        isLoading = true
        Task {
            do{
                switch queryType {
                case .random:
                    print("random")
                    meals = try await NetworkManager.shared.mealDBQuery(query: "", queryType: .random)

                case .category:
                    print("Fetching MealDB Category: \(query)")
                    var modified = query.replacingOccurrences(of: " ", with: "%20")
                    if modified == "Side%20Dish"{
                        modified = "Side"
                    }
                    meals = try await NetworkManager.shared.mealDBQuery(query: modified, queryType: .category)
                    
                    
                case .ingredient:
                    print("ing")
                case .history:
                    print("hit")
                case .favorite:
                    print("fav")
                case .none:
                    ()
                }
                isLoading = false
            }catch{
                if let apError = error as? MIError{
                    switch apError {
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
    
    
    /*
    func getRandomMeals() {
        
        isLoading = true
        Task {
            do{
                meals = try await NetworkManager.shared.mealDBRandom()
                isLoading = false
            }catch{
                if let apError = error as? MIError{
                    switch apError {
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
    */
    /*
     
     using mock data
    func getMeals(){
        do {
            if let data = MealDBJSON.sample.data(using: .utf8){
                let results = try JSONDecoder().decode(MealDBResults.Results.self, from: data)
                self.meals = results.meals
                for x in self.meals{
                    print(x.id ?? "")
                }
                
            }
        }catch let e {
            print(e)
        }
    }
    */
    
}
