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
        super.init(itemList: [])
        getUserIngredients()
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
    // MARK: - Get Ingredients
    func getUserIngredients(){
        let request = NSFetchRequest<CDIngredient>(entityName: EntityName.CDIngredient.rawValue)
        do {
            let ingredients = try PersistenceController.shared.container.viewContext.fetch(request)
            for ingredient in ingredients {
                let UUID = UUID()
                let userIngredient = Ingredients.Meals(id: UUID.uuidString,
                                                       strIngredient: ingredient.ingredient ?? "",
                                                       strDescription: nil,
                                                       strMeasurement: "",
                                                       strType: nil)

                userIngredients.insert(userIngredient, at: 0)
            }
//            userIngredients = ingredients.compactMap{$0.ingredient}
//            print("user ingredient: \(userIngredients)")
            print("user ingredient count: \(userIngredients.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
}
