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
    @ObservedObject var editIdeaVM: EditIdeaVM
    @Published var selectedArray : [String] = []
    
    init(editIdeaVM: EditIdeaVM){
        self.editIdeaVM = editIdeaVM
        selectedArray = editIdeaVM.userIngredients.compactMap{$0.name}
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
    
    func checkArray(item: String){
        // TODO:  get this to work again, check for the string value of the ingredient in the list to see if that string is in the user ingredients array
        if let repeatItem = selectedArray.firstIndex(of: item){
            editIdeaVM.userIngredients.remove(at: repeatItem)
            print("duplicate item: \(item), removed from array")
        } else {
            let newItem = UserIngredient(name: item, measurement: "")
            editIdeaVM.userIngredients.append(newItem)
            print("added item: \(item)")
        }
        selectedArray = editIdeaVM.userIngredients.compactMap{$0.name}
        
        /*
         
        if let repeatItem = editIdeaVM.userIngredients.firstIndex(of: item){
            editIdeaVM.userIngredients.remove(at: repeatItem)
            print("duplicate item: \(item), removed from array")
        } else {
            editIdeaVM.userIngredients.append(item)
            print("added item: \(item)")
        }
        selectedArray = editIdeaVM.userIngredients.compactMap{$0.name}
         */
    }
    
}
