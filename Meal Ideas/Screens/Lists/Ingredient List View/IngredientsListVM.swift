//
//  IngredientsListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation

@MainActor final class IngredientsListVM: ObservableObject{
    @Published var ingredients: [Ingredients.Meals] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    
    init(){
        getIngredients()
    }
    
    func getIngredients(){

        Task(priority: .userInitiated) {
            do {
                ingredients = try await NetworkManager.shared.getIngredients()
                ingredients = ingredients.sorted {$0.strIngredient < $1.strIngredient}
            } catch {
                DispatchQueue.main.async {
                    if let MIError = error as? MIError{
                        switch MIError {
                            //only ones that would come through should be invalidURL or invalid data, but wanted to keep the other cases
                        case .invalidURL:
                            self.alertItem = AlertContext.invalidURL
                        case .invalidData:
                            self.alertItem = AlertContext.invalidData
                        default: self.alertItem = AlertContext.invalidResponse // generic error if wanted..
                        }
                    } else {
                        self.alertItem = AlertContext.invalidResponse // generic error would go here
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
}
