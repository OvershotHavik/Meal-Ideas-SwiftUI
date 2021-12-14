//
//  IngredientsListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
import SwiftUI

@MainActor final class IngredientListVM: ObservableObject{
    @Published var ingredients: [Ingredients.Meals] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @ObservedObject var editVM: EditIdeaVM
    @Published var selectedArray : [String] = []
    
    @Published var selection: String?
    @Published var searching = false
    @Published var mainList : [String] = []
    
    @Published var searchText = ""
    var searchResults: [Ingredients.Meals] {
        if searchText.isEmpty {
            return ingredients
        } else {
            return ingredients.filter { $0.strIngredient.contains(searchText) }
        }
    }
    
    init(editIdeaVM: EditIdeaVM){
        self.editVM = editIdeaVM
        selectedArray = editIdeaVM.userIngredients.compactMap{$0.name}
        getIngredients()
    }
    
    func getIngredients(){
        Task(priority: .userInitiated) {
            do {
                ingredients = try await NetworkManager.shared.getIngredients()
                ingredients = ingredients.sorted {$0.strIngredient < $1.strIngredient}
                mainList = ingredients.compactMap{$0.strIngredient}

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
    
    func checkArray(item: String){
        if let repeatItem = selectedArray.firstIndex(of: item){
            editVM.userIngredients.remove(at: repeatItem)
            print("duplicate item: \(item), removed from array")
        } else {
            let newItem = UserIngredient(name: item, measurement: "")
            editVM.userIngredients.append(newItem)
            editVM.userIngredients = editVM.userIngredients.sorted{$0.name < $1.name}
            print("added item: \(item)")
        }
        selectedArray = editVM.userIngredients.compactMap{$0.name}
    }
    

}
