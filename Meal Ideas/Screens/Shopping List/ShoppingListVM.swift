//
//  ShoppingListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/19/22.
//

import Foundation
import CoreData
class ShoppingListVM: ObservableObject{
//    @Published var allShoppingList: [ShoppingList] = []
//    @Published var anyChecked = false
//    @Published var mealNames: [String] = []
//
//    func getShoppingList(){
//        let request = NSFetchRequest<ShoppingList>(entityName: EntityName.ShoppingList.rawValue)
//        do {
//            allShoppingList = []
//            mealNames = []
//
//            allShoppingList = try PersistenceController.shared.container.viewContext.fetch(request)
//            mealNames = allShoppingList.compactMap({$0.mealName}).unique().sorted(by: {$0 < $1})
//            for item in allShoppingList{
//                print("mealName: \(item.mealName ?? ""), ingredient: \(item.ingredient ?? ""), measurement: \(item.measurement ?? "")")
//            }
//
//            let verifyCheck = allShoppingList.compactMap({$0.checkedOff})
//            if verifyCheck.contains(true){
//                anyChecked = true
//            } else {
//                anyChecked = false
//            }
//        } catch let error {
//            print("error fetching: \(error.localizedDescription)")
//        }
//    }
    
}
