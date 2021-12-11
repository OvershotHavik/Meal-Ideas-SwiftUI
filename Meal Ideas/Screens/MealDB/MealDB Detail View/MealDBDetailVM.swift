//
//  MealDBDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation

@MainActor final class MealDBDetailVM: ObservableObject{
    @Published var meal: MealDBResults.Meal
    @Published var isLoading = false
    init(meal : MealDBResults.Meal){
        self.meal = meal
        fetchMeal()
    }
    
    func fetchMeal(){
        let mealID = meal.id
        print("Fetching MealDB Single Named mealID: \(mealID ?? "")")
        isLoading = false
        Task {
            do {
                let results = try await NetworkManager.shared.mealDBQuery(query: mealID ?? "", queryType: .none)
                if let safeResults = results.first{
                    meal = safeResults
                }
            }
        }
    }
}

