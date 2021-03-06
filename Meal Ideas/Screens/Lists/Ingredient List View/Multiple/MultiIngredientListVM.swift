//
//  MultiIngredientListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/22/22.
//

import SwiftUI
import CoreData

@MainActor final class MultiIngredientListVM: IngredientListVM{
    @ObservedObject var editVM: EditIdeaVM
    //For the alert to add items to the list
    @Published var showTextAlert = false
    @Published var listType: ListType
    
    init(editVM: EditIdeaVM, listType: ListType){
        self.editVM = editVM
        self.listType = listType
        super.init(itemList: [], selection: nil)
        getUserIngredients()
        selectedArray = editVM.userIngredients.compactMap{$0.name}
    }
    

    func checkArray(item: String, allShoppingList: [ShoppingList]){
        if let repeatItem = selectedArray.firstIndex(of: item){
            editVM.userIngredients.remove(at: repeatItem)
            print("duplicate item: \(item), removed from array")
            if let existing = allShoppingList.filter({$0.ingredient == item}).first{
                PersistenceController.shared.removeFromShoppingList(mealName: Misc.mealName.rawValue,
                                                                    ingredient: item,
                                                                    measurement: existing.measurement,
                                                                    checkedOff: false)
            }
        } else {
            let newItem = UserIngredient(name: item, measurement: "")
            editVM.userIngredients.append(newItem)
            editVM.userIngredients = editVM.userIngredients.sorted{$0.name < $1.name}
            print("added item: \(item)")
        }
        selectedArray = editVM.userIngredients.compactMap{$0.name}
    }


    private func getUserIngredients(){
        let request = NSFetchRequest<CDIngredient>(entityName: EntityName.CDIngredient.rawValue)
        do {
            let ingredients = try PersistenceController.shared.container.viewContext.fetch(request)
            for ingredient in ingredients {
                // Convert the string of the ingredient name to a listIngredient to be able to have it show up on the list for the user to select
                let UUID = UUID()
                let listIngredient = Ingredients.Meals(id: UUID.uuidString,
                                                       strIngredient: ingredient.ingredient ?? "",
                                                       strDescription: nil,
                                                       strMeasurement: "",
                                                       strType: nil)
                userIngredients.append(listIngredient)
            }
            print("user ingredient count: \(userIngredients.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    

    func addItem(item: String){
        //add item to the selected array and add it to the list so user can uncheck it if they want
        selectedArray.append(item)
        if !ingredients.contains(where: {$0.strIngredient == item}){
            //Item is not in the list, add it to the core data and ingredients, otherwise just add it to the selected array above
            let UUID = UUID()
            let listIngredient = Ingredients.Meals(id: UUID.uuidString,
                                                   strIngredient: item,
                                                   strDescription: nil,
                                                   strMeasurement: "",
                                                   strType: nil)
            ingredients.append(listIngredient)
            ingredients = ingredients.sorted{$0.strIngredient < $1.strIngredient}
            
            //Convert the string to a user ingredient to be added to the array of User Ingredients to then be shown on the previous screen or unchecked here
            let userIngredient = UserIngredient(id: UUID,
                                                name: item,
                                                measurement: "")
            editVM.userIngredients.append(userIngredient)
            PersistenceController.shared.addUserItem(entityName: .CDIngredient, item: item)
        }
    }
}
