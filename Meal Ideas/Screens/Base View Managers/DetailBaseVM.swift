//
//  DetailBaseVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/9/22.
//

import SwiftUI
import CoreData

class DetailBaseVM: ObservableObject{
    @Published var isLoading = false
    @Published var alertItem : AlertItem?
    @Published var ingredients: [String] = []
    @Published var measurements: [String] = []
    @Published var instructions: String = ""
    @Published var mealPhoto = UIImage()
    @Published var favorited = false
    @Published var showingHistory =  false
    @Published var backgroundColor = Color(UIColor.secondarySystemBackground)
    @Published var isShareSheetShowing = false
//    @Published var checkedOff = false // if this changes, update
    
    // MARK: - Present Share Action Sheet
    func presentShareAS(website: String?){
        isShareSheetShowing.toggle()
        if let safeWebsite = website{
            let shareActionSheet = UIActivityViewController(activityItems: [safeWebsite],  applicationActivities: nil)
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            window?.rootViewController?.present(shareActionSheet, animated: true, completion: nil)
        }
    }
    
    // MARK: - Check ShoppingList
    //may need t move to an environment along with the storage of the list so it doesn't need called every single time.. we'll see
    func checkShoppingList(mealName: String, ingredient: String) -> Bool{
        let request = NSFetchRequest<ShoppingList>(entityName: EntityName.ShoppingList.rawValue)
        do {
            let savedList = try PersistenceController.shared.container.viewContext.fetch(request)
            if savedList.firstIndex(where: {$0.mealName == mealName && $0.ingredient == ingredient}) != nil {
                // meal and ingredient already in list
                return true
            } else {
                //not in the list
                return false
            }
        } catch let e{
            print("Error loading shopping list in detail vm: \(e.localizedDescription)")
        }

        return false
    }
}
