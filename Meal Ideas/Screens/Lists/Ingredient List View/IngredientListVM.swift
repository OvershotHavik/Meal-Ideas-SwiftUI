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
    
    func checkArray(item: UserIngredient){
        
        let filtered = editIdeaVM.userIngredients.compactMap{$0.name}
        if filtered.contains(item.name){
            if let repeatItem = editIdeaVM.userIngredients.firstIndex(of: item){
                editIdeaVM.userIngredients.remove(at: repeatItem)
                print("duplicate item: \(item), removed from array")
            }
        } else {
            editIdeaVM.userIngredients.append(item)
            print("added item: \(item)")
        }
        
        /*
        if let repeatItem = editIdeaVM.userIngredients.firstIndex(of: item){
            editIdeaVM.userIngredients.remove(at: repeatItem)
            print("duplicate item: \(item), removed from array")
        } else {
            editIdeaVM.userIngredients.append(item)
            print("added item: \(item)")
        }
         */
        selectedArray = editIdeaVM.userIngredients.compactMap{$0.name}
    }
    
}
