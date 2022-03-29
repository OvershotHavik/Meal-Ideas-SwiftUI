//
//  ShoppingListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/19/22.
//

import SwiftUI
import CoreData


class ShoppingListVM: ObservableObject{
    @Published var searchText = ""
    @Published var allShoppingList: [ShoppingList] = []
    @Published var anyChecked = false
    @Published var mealNames: [String] = []
    @Published var showingClearAllAlert = false
    @Published var showingClearCheckedAlert = false
    private var sharedString = ""
    @Published var isShareSheetShowing = false
    
    var searchResults: [ShoppingList] {
        if searchText.isEmpty {
            return allShoppingList
        } else {
            return allShoppingList.filter { $0.ingredient!.containsIgnoringCase(find: searchText) }
        }
    }

    
    func shareTapped(allShoppingList: [ShoppingList]){
        sharedString = "Shopping List:\n"
        for meal in mealNames{
            let filteredMeals = searchResults.filter({$0.mealName == meal})
            sharedString += "\(meal):\n"
            for item in filteredMeals{
                let check = "\(item.checkedOff ? "☑️" : " ")"
                if item.measurement != ""{
                    sharedString += "\(item.ingredient ?? "") - \(item.measurement ?? "") \(check)\n"
                } else {
                    sharedString += "\(item.ingredient ?? "") \(check) \n"
                }
            }
            sharedString += "\n"
        }
        print(sharedString)
        presentShareAS(sharedString: sharedString)
    }
    
    
    func presentShareAS(sharedString: String?){
        isShareSheetShowing.toggle()
        if let safeWebsite = sharedString{
            let shareActionSheet = UIActivityViewController(activityItems: [safeWebsite],  applicationActivities: nil)
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.rootViewController?.present(shareActionSheet, animated: true, completion: nil)
        }
    }
}
