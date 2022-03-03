//
//  MiscMealVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 3/3/22.
//

import Foundation
import CoreData

final class MiscMealVM: EditIdeaVM{
    func convertToUserIngredient(allShoppingList: [ShoppingList]){
        if userIngredients.isEmpty{
            for item in allShoppingList{
                if item.mealName == Misc.mealName.rawValue{
                    let ingredient = UserIngredient(name: item.ingredient ?? "", measurement: item.measurement ?? "")
                    self.userIngredients.append(ingredient)
                }
            }
        }
        userIngredients = userIngredients.sorted(by: {$0.name < $1.name})
    }
    
    
    func convertToShoppingList(allShoppingList: [ShoppingList]){
        for item in self.userIngredients{
            print("Item: \(item.name), measurement: \(item.measurement)")
            if allShoppingList.filter({$0.ingredient == item.name}).first != nil{
                //ingredient already exists, update the measurement and save
                PersistenceController.shared.updateMiscMealItem(mealName: Misc.mealName.rawValue,
                                                                ingredient: item.name,
                                                                measurement: item.measurement)
            } else {
                //Not in the list, add to shopping list
                PersistenceController.shared.addToShoppingList(mealName: Misc.mealName.rawValue,
                                                               ingredient: item.name,
                                                               measurement: item.measurement,
                                                               checkedOff: false)
            }
        }
    }
    
    
   override func deleteIngredient(at offsets: IndexSet){
        userIngredients.remove(atOffsets: offsets)
       PersistenceController.shared.deleteInList(indexSet: offsets,
                                                 entityName: .ShoppingList,
                                                 source: .myIdeas)
    }
}
