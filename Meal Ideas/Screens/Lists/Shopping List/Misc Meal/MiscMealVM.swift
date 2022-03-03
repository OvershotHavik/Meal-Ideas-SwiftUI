//
//  MiscMealVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 3/3/22.
//

import Foundation
import CoreData

final class MiscMealVM: EditIdeaVM{
    let miscMealName = "misc"
    func convertToUserIngredient(allShoppingList: [ShoppingList]){
        if userIngredients.isEmpty{
            for item in allShoppingList{
                if item.mealName == miscMealName{
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
                PersistenceController.shared.updateMiscMealItem(mealName: miscMealName,
                                                                ingredient: item.name,
                                                                measurement: item.measurement)
            } else {
                //Not in the list, add to shopping list
                PersistenceController.shared.addToShoppingList(mealName: miscMealName,
                                                               ingredient: item.name,
                                                               measurement: item.measurement,
                                                               checkedOff: false)
            }
        }
    }
}
