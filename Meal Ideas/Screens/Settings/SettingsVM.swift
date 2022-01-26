//
//  SettingsVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import Foundation
import CoreData

@MainActor final class SettingsVM: ObservableObject{
    @Published var test = ""
    @Published var userIngredients: [String] = []
    @Published var userCategories: [String] = []
    @Published var userSides: [String] = []
    
    init(){
        getUserItems()
    }
    
    // MARK: - Get Ingredients
    func getUserItems(){
        let categoriesRequest = NSFetchRequest<CDUserCategory>(entityName: EntityName.CDUserCategory.rawValue)
        do {
            let categories = try PersistenceController.shared.container.viewContext.fetch(categoriesRequest)
            userCategories = categories.compactMap{$0.category}
            print("categories count: \(userCategories.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
        
        
        let ingredientRequest = NSFetchRequest<CDIngredient>(entityName: EntityName.CDIngredient.rawValue)
        do {
            let ingredients = try PersistenceController.shared.container.viewContext.fetch(ingredientRequest)
            userIngredients = ingredients.compactMap({$0.ingredient})
            print("user ingredient count: \(userIngredients.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
        

        let sidesRequest = NSFetchRequest<CDUserSides>(entityName: EntityName.CDUserSides.rawValue)
        do {
            let sides = try PersistenceController.shared.container.viewContext.fetch(sidesRequest)
            userSides = sides.compactMap({$0.side})
            print("User sides: \(userSides)")
            
            print("sides count: \(userSides.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    

}
