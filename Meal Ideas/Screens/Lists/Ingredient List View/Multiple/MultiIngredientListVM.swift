//
//  MultiIngredientListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/22/22.
//

import SwiftUI

@MainActor final class MultiIngredientListVM: IngredientListVM{
    @ObservedObject var editVM: EditIdeaVM

    init(editVM: EditIdeaVM){
        self.editVM = editVM
        super.init(itemList: [])
        selectedArray = editVM.userIngredients.compactMap{$0.name}
        
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
