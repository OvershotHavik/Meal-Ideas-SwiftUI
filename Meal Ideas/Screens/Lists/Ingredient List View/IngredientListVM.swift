//
//  IngredientsListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

@MainActor class IngredientListVM: ObservableObject{
    @Published var itemList: [String]
    @Published var ingredients: [Ingredients.Meals] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var selectedArray : [String] = []
    @Published var showNoResults = false
    @Published var selection: String?
    @Published var searching = false
    @Published var userIngredients : [Ingredients.Meals] = []
    @Published var searchText = ""
    var searchResults: [Ingredients.Meals] {
        if searchText.isEmpty {
            return ingredients
        } else {
            return ingredients.filter { $0.strIngredient.contains(searchText) }
        }
    }
    
    init(itemList: [String], selection: String?){
        self.itemList = itemList
        self.selection = selection
        getIngredients()
    }
    
    func getIngredients(){
        self.isLoading = true
        Task(priority: .userInitiated) {
            do {
                let allIngredients = try await NetworkManager.shared.getIngredients()
                ingredients = allIngredients.sorted {$0.strIngredient < $1.strIngredient}
                if !itemList.isEmpty{
                    ingredients = ingredients.filter { itemList.contains($0.strIngredient)}
                    showNoResults = false
                } else {
                    ingredients.append(contentsOf: userIngredients)
                }
                ingredients = ingredients.sorted{$0.strIngredient < $1.strIngredient}
                self.isLoading = false
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
