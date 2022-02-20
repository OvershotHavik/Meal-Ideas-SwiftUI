//
//  ShoppingListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/19/22.
//

import Foundation
import CoreData
class ShoppingListVM: ObservableObject{
    @Published var searchText = ""
    @Published var allShoppingList: [ShoppingList] = []
    @Published var anyChecked = false
    @Published var mealNames: [String] = []
    
    var searchResults: [ShoppingList] {
        if searchText.isEmpty {
            return allShoppingList
        } else {
            return allShoppingList.filter { $0.ingredient!.containsIgnoringCase(find: searchText) }
        }
    }
}
