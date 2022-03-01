//
//  Persistence.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()


    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Meal_Ideas")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
    }


    func saveData(completion: @escaping (Result<MISuccess, MIError>) throws -> Void ){
        do{
            try container.viewContext.save()
            print("successfully saved")
            try completion(.success(.successfullySaved))
        } catch let error{
            do {
                try completion(.failure(.unableToSave))
                print("error saving meals to core data: \(error.localizedDescription)")
            } catch let e{
                print("error after completion failure: \(e.localizedDescription)")
            }
        }
    }


    func saveData(){
        do{
            try container.viewContext.save()
        } catch let error{
            print("error saving meals to core data: \(error.localizedDescription)")
        }
    }


    func deleteInList(indexSet: IndexSet, entityName: EntityName, source: Source){
        switch entityName {
        case .userMeals:
            let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
            do {
                let savedMeals = try container.viewContext.fetch(request).sorted{$0.mealName ?? "" < $1.mealName ?? ""}
                guard let index = indexSet.first else {return}
                let meal = savedMeals[index]
                clearHistory(meal: meal)
                deleteFavorite(source: .myIdeas,
                               mealName: meal.mealName ?? "",
                               mealDBID: nil,
                               spoonID: nil,
                               userMealID: meal.userMealID)
                container.viewContext.delete(meal)
            } catch let error {
                print("error fetching: \(error.localizedDescription)")
            }
            
            
        case .history:
            let request = NSFetchRequest<History>(entityName: EntityName.history.rawValue)
            guard let index = indexSet.first else {return}

            do{
                let savedHistory = try container.viewContext.fetch(request).sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
                switch source {
                case .spoonacular:
                    let spoonHistory = savedHistory.filter{$0.spoonID != 0}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
                    let history = spoonHistory[index]
                    container.viewContext.delete(history)
                    
                    
                case .mealDB:
                    let mealDBHistory = savedHistory.filter {$0.mealDBID != nil}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
                    let history = mealDBHistory[index]
                    container.viewContext.delete(history)
                    
                    
                case .myIdeas:
                    let myIdeasHistory = savedHistory.filter{$0.userMealID != nil}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
                    let history = myIdeasHistory[index]
                    container.viewContext.delete(history)
                    

                }
                guard let index = indexSet.first else {return}
                let history = savedHistory[index]
                container.viewContext.delete(history)
            } catch let e{
                print("Error fetching history: \(e.localizedDescription)")
            }
            
            
        case .favorites:
            let request = NSFetchRequest<Favorites>(entityName: EntityName.favorites.rawValue)
            guard let index = indexSet.first else {return}
            do {
                let savedFavorites = try container.viewContext.fetch(request)
                switch source {
                case .spoonacular:
                    let spoonFavorites = savedFavorites.filter{$0.spoonID != 0}.sorted{$0.mealName ?? "" < $1.mealName ?? ""}
                    let favorite = spoonFavorites[index]
                    container.viewContext.delete(favorite)
                    
                    
                case .mealDB:
                    let mealDBFavorites = savedFavorites.filter {$0.mealDBID != nil}.sorted{$0.mealName ?? "" < $1.mealName ?? ""}
                    let favorite = mealDBFavorites[index]
                    container.viewContext.delete(favorite)
                    
                    
                case .myIdeas:
                    let myFavorites = savedFavorites.filter{$0.userMealID != nil}.sorted{$0.mealName ?? "" < $1.mealName ?? ""}
                    let favorite = myFavorites[index]
                    container.viewContext.delete(favorite)
                }

            } catch let e{
                print("Error fetching favorites: \(e.localizedDescription)")
            }
            
            
        case .CDIngredient:
            let request = NSFetchRequest<CDIngredient>(entityName: EntityName.CDIngredient.rawValue)
            do {
                let savedIngredients = try container.viewContext.fetch(request)
                guard let index = indexSet.first else {return}
                let ingredient = savedIngredients[index]
                print(ingredient)
                container.viewContext.delete(ingredient)
                //Delete the ingredient from any meals that may have it in them
                let mealRequest = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
                
                if let ingredientName = ingredient.ingredient{
                    let savedMeals = try container.viewContext.fetch(mealRequest)
                    for meal in savedMeals{
                        if let safeIngredients = meal.ingredients as? [String]{
                            if safeIngredients.contains(ingredientName){
                                print("Meal: \(meal.mealName ?? "") with ingredient: \(ingredientName)")
                                
                                var savedIngredients = safeIngredients
                                print("Ingredients: \(savedIngredients)")
                                if let existingIngredient = savedIngredients.firstIndex(of: ingredientName){
                                    savedIngredients.remove(at: existingIngredient)
                                    meal.ingredients = savedIngredients as NSObject
                                    print("Ingredients after removal: \(savedIngredients)")
                                    saveData()
                                    print("Meal saved")
                                }
                            }
                        }
                    }
                }
            }catch let e {
                print("Error fetching CDIngredients: \(e.localizedDescription)")
            }

            
        case .CDCategory:
            let request = NSFetchRequest<CDCategory>(entityName: EntityName.CDCategory.rawValue)
            do {
                let savedItems = try container.viewContext.fetch(request)
                guard let index = indexSet.first else {return}
                let category = savedItems[index]
                print(category)
                container.viewContext.delete(category)
                //Delete the Category from any meals that may have it in them

                let mealRequest = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)

                if let categoryName = category.category{
                    let savedMeals = try container.viewContext.fetch(mealRequest)
                    for meal in savedMeals{
                        if let safeCategories = meal.category as? [String]{
                            if safeCategories.contains(categoryName){
                                print("Meal: \(meal.mealName ?? "") with category: \(categoryName)")
                                var savedCategories = safeCategories
                                print("Categories: \(savedCategories)")
                                
                                if let existingCategory = savedCategories.firstIndex(of: categoryName){
                                    savedCategories.remove(at: existingCategory)
                                    meal.category = savedCategories as NSObject
                                    print("Catagories after removal: \(savedCategories)")
                                    saveData()
                                    print("Meal saved")
                                }
                            }
                        }
                    }
                }
            }catch let e {
                print("Error fetching CDUserCategory: \(e.localizedDescription)")
            }
            
            
        case .CDSides:
            let request = NSFetchRequest<CDSides>(entityName: EntityName.CDSides.rawValue)
            do {
                let savedItems = try container.viewContext.fetch(request)
                guard let index = indexSet.first else {return}
                let side = savedItems[index]
                print(side)
                container.viewContext.delete(side)
                //Delete the Side from any meals that may have it in them

                let mealRequest = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)

                if let sideName = side.side{
                    let savedMeals = try container.viewContext.fetch(mealRequest)
                    for meal in savedMeals{
                        if let safeSides = meal.sides as? [String]{
                            if safeSides.contains(sideName){
                                print("Meal \(meal.mealName ?? "") with side: \(sideName)")
                                var savedSides = safeSides
                                print("Sides: \(savedSides)")
                                
                                if let existingSide = savedSides.firstIndex(of: sideName){
                                    savedSides.remove(at: existingSide)
                                    meal.sides = savedSides as NSObject
                                    print("SIdes after removal: \(savedSides)")
                                    saveData()
                                    print("Meal saved")
                                }
                            }
                        }
                    }
                }
                    
                
            }catch let e {
                print("Error fetching CDUserCategory: \(e.localizedDescription)")
            }
        case .ShoppingList:
            print("Shopping list not setup in delete from list")
        }
        saveData()
    }


    func deleteMeal(meal: UserMeals){
        container.viewContext.delete(meal)
        print("meal deleted")
    }
    
    
    func saveFavorites(mealName: String, mealDBID: String?, spoonID: Int?, userMealID: UUID?){
        let newFavorite = Favorites(context: container.viewContext)
        newFavorite.mealName = mealName
        newFavorite.mealDBID = mealDBID
        newFavorite.userMealID = userMealID
        if let safeSpoonID = spoonID{
            let safeDouble : Double  = Double(safeSpoonID)
            newFavorite.spoonID = safeDouble
        }
        newFavorite.dateAdded = Date()
        saveData()
    }


    func deleteFavorite(source: Source, mealName: String, mealDBID: String?, spoonID: Double?, userMealID: UUID?){
        let request = NSFetchRequest<Favorites>(entityName: EntityName.favorites.rawValue)
        do {
            let savedFavorites = try container.viewContext.fetch(request)
            print("favorites fetched in delete favorite")
            switch source {
            case .spoonacular:
                guard let index = savedFavorites.firstIndex(where: {$0.mealName == mealName && $0.spoonID == spoonID}) else {return}
                let favoriteToDelete = savedFavorites[index]
                container.viewContext.delete(favoriteToDelete)
                
                
            case .mealDB:
                guard let index = savedFavorites.firstIndex(where: {$0.mealName == mealName && $0.mealDBID == mealDBID}) else {return}
                let favoriteToDelete = savedFavorites[index]
                container.viewContext.delete(favoriteToDelete)
                
                
            case .myIdeas:
                guard let index = savedFavorites.firstIndex(where: {$0.mealName == mealName && $0.userMealID == userMealID}) else {return}
                let favoriteToDelete = savedFavorites[index]
                
                container.viewContext.delete(favoriteToDelete)
            }
            print("removed favorite \(mealName)")
            saveData()

        }catch let e{
            print("Error fetching favorites in deleteFavorites \(e.localizedDescription)")
        }
    }


    func addToHistory(mealName: String, mealDBID: String?, spoonID: Int?, userMealID: UUID?){
        let newHistory = History(context: container.viewContext)
        newHistory.mealName = mealName
        newHistory.mealDBID = mealDBID
        newHistory.userMealID = userMealID
        if let safeSpoonID = spoonID{
            let safeDouble: Double = Double(safeSpoonID)
            newHistory.spoonID = safeDouble
        }
        newHistory.timeStamp = Date()
        saveData()
    }
    

    func clearHistory(meal: UserMeals){
        //Clear history of the previous meal name to prevent crashes due to the name/meal no longer existing
        
        let request = NSFetchRequest<History>(entityName: EntityName.history.rawValue)
        do{
            let allHistory = try container.viewContext.fetch(request)
            let filtered = allHistory.filter{$0.mealName == meal.mealName}
            
            for meal in filtered{
                print("Deleting meal: \(meal.mealName ?? "") from history")
                container.viewContext.delete(meal)
            }
            saveData()
            
        }catch let e{
            print("Error clearing history in edit meal: \(e.localizedDescription) ")
        }
    }


    func deleteHistory(source: Source, deleteOption: Date, completed: () -> Void){
        
        let request = NSFetchRequest<History>(entityName: EntityName.history.rawValue)
        do {
            let savedHistory = try container.viewContext.fetch(request)
            switch source {
            case .spoonacular:
                let filtered = savedHistory.filter({$0.timeStamp! < deleteOption && $0.mealDBID == nil})

                for meal in filtered{
                    print("Meal name: \(meal.mealName ?? "") to be deleted from history")
                    container.viewContext.delete(meal)
                }
                saveData()
                completed()
                
            case .mealDB:
                let filtered = savedHistory.filter({$0.timeStamp! < deleteOption && $0.mealDBID != nil})
                for meal in filtered{
                    print("Meal name: \(meal.mealName ?? "") to be deleted from history")
                    container.viewContext.delete(meal)
                }
                saveData()
                completed()
                
            case .myIdeas:
                let filtered = savedHistory.filter({$0.timeStamp! < deleteOption && $0.mealDBID == nil && $0.spoonID == 0})
                for meal in filtered{
                    print("Meal name: \(meal.mealName ?? "") to be deleted from history")
                    container.viewContext.delete(meal)
                }
                saveData()
                completed()
            }
        } catch let e {
            print("Error fetching history in Delete History: \(e.localizedDescription)")
        }
    }


    func addUserItem(entityName: EntityName, item: String){
        switch entityName {
        case .CDIngredient:
            let newItem = CDIngredient(context: container.viewContext)
            newItem.ingredient = item
            print("adding to CDIngredients: \(item)")
            
            
        case .CDCategory:
            let newItem = CDCategory(context: container.viewContext)
            newItem.category = item
            print("adding to CDUserCategory: \(item)")
            
            
        case .CDSides:
            let newItem = CDSides(context: container.viewContext)
            newItem.side = item
            print("adding to CDUserSides: \(item)")
            
            
        default: print("Not setup in addUserItem")
        }
        saveData()
    }
    
    
    func editUserItem(entityName: EntityName, original: String, updated: String?){
        //If updated is nil, user selected delete
        switch entityName {
        case .CDCategory:
            let request = NSFetchRequest<CDCategory>(entityName: EntityName.CDCategory.rawValue)
            do {
                let savedItems = try container.viewContext.fetch(request)
                guard let index = savedItems.firstIndex(where: {$0.category == original}) else {return}
                let category = savedItems[index]
                print(category)

                //Delete the Category from any meals that may have it in them

                let mealRequest = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)

                if let categoryName = category.category{
                    let savedMeals = try container.viewContext.fetch(mealRequest)
                    for meal in savedMeals{
                        if let safeCategories = meal.category as? [String]{
                            if safeCategories.contains(categoryName){
                                print("Meal: \(meal.mealName ?? "") with category: \(categoryName)")
                                var savedCategories = safeCategories
                                print("Categories: \(savedCategories)")
                                
                                if let existingCategory = savedCategories.firstIndex(of: categoryName){
                                    //Remove from the array
                                    savedCategories.remove(at: existingCategory)
                                    if let safeUpdated = updated{
                                        //add updated
                                        savedCategories.append(safeUpdated)
                                    }
                                    meal.category = savedCategories as NSObject
                                    print("Categories after update: \(savedCategories)")
                                    saveData()
                                    print("Meal saved")
                                }
                            }
                        }
                    }
                }
                    
                if updated == nil{
                    print("delete tapped, removing")
                    //user selected delete, delete it from the CD
                    container.viewContext.delete(category)
                } else {
                    //Update the side
                    print("Update tapped")
                    category.category = updated
                    saveData()
                }
                
                
            }catch let e {
                print("Error fetching CDUserCategory: \(e.localizedDescription)")
            }

            
        case .CDIngredient:
            let request = NSFetchRequest<CDIngredient>(entityName: EntityName.CDIngredient.rawValue)
            do {
                let savedIngredients = try container.viewContext.fetch(request)
                guard let index = savedIngredients.firstIndex(where: {$0.ingredient == original}) else {return}
                let ingredient = savedIngredients[index]
                print(ingredient)

                //Update the ingredient from any meals that may have it in them

                let mealRequest = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
                
                if let ingredientName = ingredient.ingredient{
                    let savedMeals = try container.viewContext.fetch(mealRequest)
                    for meal in savedMeals{
                        if let safeIngredients = meal.ingredients as? [String]{
                            if safeIngredients.contains(ingredientName){
                                print("Meal: \(meal.mealName ?? "") with ingredient: \(ingredientName)")
                                var savedIngredients = safeIngredients
                                print("Ingredients: \(savedIngredients)")
                                if let existingIngredient = savedIngredients.firstIndex(of: ingredientName){
                                    //Remove from the array
                                    savedIngredients.remove(at: existingIngredient)
                                    if let safeUpdated = updated{
                                        // add updated
                                        savedIngredients.append(safeUpdated)
                                    }
                                    meal.ingredients = savedIngredients as NSObject
                                    print("Ingredients after removal: \(savedIngredients)")
                                    saveData()
                                    print("Meal saved")
                                }
                            }
                        }
                    }
                }
                
                if updated == nil{
                    print("delete tapped, removing")
                    //user selected delete, delete it from the CD
                    container.viewContext.delete(ingredient)
                } else {
                    //Update the side
                    print("Update tapped")
                    ingredient.ingredient = updated
                    saveData()
                }
            }catch let e {
                print("Error fetching CDIngredients: \(e.localizedDescription)")
            }
            
            
        case .CDSides:
            let request = NSFetchRequest<CDSides>(entityName: EntityName.CDSides.rawValue)
            do {
                
                let savedItems = try container.viewContext.fetch(request)
                guard let index = savedItems.firstIndex(where: {$0.side == original}) else {return}
                let side = savedItems[index]
                print(side)


                //Update the Side from any meals that may have it in them

                let mealRequest = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)

                if let sideName = side.side{
                    let savedMeals = try container.viewContext.fetch(mealRequest)
                    for meal in savedMeals{
                        if let safeSides = meal.sides as? [String]{
                            if safeSides.contains(sideName){
                                print("Meal \(meal.mealName ?? "") with side: \(sideName)")
                                var savedSides = safeSides
                                print("Sides: \(savedSides)")
                                
                                if let existingSide = savedSides.firstIndex(of: sideName){
                                    //Remove from the array
                                    savedSides.remove(at: existingSide)
                                    if let safeUpdated = updated{
                                        //Add updated
                                        savedSides.append(safeUpdated)
                                    }
                                    meal.sides = savedSides as NSObject
                                    print("SIdes after removal: \(savedSides)")
                                    saveData()
                                    print("Meal saved")
                                }
                            }
                        }
                    }
                }
                if updated == nil{
                    print("delete tapped, removing")
                    //user selected delete, delete it from the CD
                    container.viewContext.delete(side)
                } else {
                    //Update the side
                    print("Update tapped")
                    side.side = updated
                    saveData()
                }
                    
                    
            }catch let e {
                print("Error fetching CDUserCategory: \(e.localizedDescription)")
            }
            
        default: print("Not setup in EditUserItems")
        }
        saveData()
    }
    
    
    func addToShoppingList(mealName: String, ingredient: String?, measurement: String?, checkedOff: Bool){
        let newShoppingListItem = ShoppingList(context: container.viewContext)
        newShoppingListItem.mealName = mealName
        newShoppingListItem.ingredient = ingredient
        newShoppingListItem.measurement = measurement
        newShoppingListItem.checkedOff = checkedOff
        print("Adding \(mealName) - \(ingredient ?? "") - \(measurement ?? "") to shopping list")
        saveData()
    }
    

    func removeFromShoppingList(mealName: String, ingredient: String?, measurement: String?, checkedOff: Bool){
        let request = NSFetchRequest<ShoppingList>(entityName: EntityName.ShoppingList.rawValue)

        do{
            let savedItems = try container.viewContext.fetch(request)
            guard let index = savedItems.firstIndex(where: {$0.mealName == mealName && $0.ingredient == ingredient && $0.measurement == measurement}) else {return}
            let shoppingListItem = savedItems[index]
            print("removing \(mealName) - \(ingredient ?? "") - \(measurement ?? "") from shopping list")
            print("removing: \(shoppingListItem)")
            container.viewContext.delete(shoppingListItem)
            saveData()
        }catch let e {
            print("Error fetching Shopping list: \(e.localizedDescription)")
        }
    }
    

    func clearAllShoppingList(){
        let request = NSFetchRequest<ShoppingList>(entityName: EntityName.ShoppingList.rawValue)

        do{
            let savedItems = try container.viewContext.fetch(request)
            for item in savedItems{
                container.viewContext.delete(item)
            }
            print("Cleared shopping list")
            saveData()
        }catch let e {
            print("Error fetching Shopping list: \(e.localizedDescription)")
        }
    }
    

    func updateShoppingListItem(mealName: String, ingredient: String, measurement: String, checkedOff: Bool){
        let request = NSFetchRequest<ShoppingList>(entityName: EntityName.ShoppingList.rawValue)

        do {
            let savedItems = try container.viewContext.fetch(request)
            let filtered = savedItems.filter({$0.mealName == mealName && $0.ingredient == ingredient && $0.measurement == measurement})
            //Instead of doing the index, this goes through for any duplicates of the item to modify the record accordingly. 
            for item in filtered{
                let shoppingListItem = item
                shoppingListItem.checkedOff = checkedOff
                saveData()
            }
        }catch let e {
            print("Error fetching Shopping list: \(e.localizedDescription)")
        }
    }
    

    func removeCheckedItems(){
        let request = NSFetchRequest<ShoppingList>(entityName: EntityName.ShoppingList.rawValue)

        do{
            let savedItems = try container.viewContext.fetch(request)
            for item in savedItems{
                if item.checkedOff{
                    container.viewContext.delete(item)
                }
            }
            saveData()
        }catch let e {
            print("Error fetching Shopping list: \(e.localizedDescription)")
        }
    }
}
