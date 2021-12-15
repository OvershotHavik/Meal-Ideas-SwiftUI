//
//  Persistence.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import CoreData
import SwiftUI

struct UserMealsPC {
    static let shared = UserMealsPC()


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
    }
// MARK: - Save Data with completion
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
    // MARK: - Save without completion
    func saveData(){
        do{
            try container.viewContext.save()
        } catch let error{
            print("error saving meals to core data: \(error.localizedDescription)")
        }
    }
    
    func deleteMealInList(indexSet: IndexSet){
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        do {
            let savedMeals = try container.viewContext.fetch(request)
            print("Meals Fetched in delete meal")
            guard let index = indexSet.first else {return}
            let meal = savedMeals[index]
            container.viewContext.delete(meal)
            saveData()
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    func deleteMeal(meal: UserMeals){
        
        container.viewContext.delete(meal)
        print("meal deleted")
        
        
        // TODO:  change to completion once verified working
//        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        /*
        do {
//            let savedMeals = try container.viewContext.fetch(request)
            container.viewContext.delete(meal)
            print("meal deleted")
        }
        catch let error{
            print("error fetching: \(error.localizedDescription)")

        }
         */
    }
    
    /*
    // MARK: - Save
    func save(completion: @escaping (Error?) -> () = { _ in }) {
        withAnimation {
            let context = container.viewContext
            if context.hasChanges{
                do {
                    try context.save()
                    completion(nil)
                }catch {
                    completion(error)
                }
            }
        }

    }
    
// MARK: - Delete
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = { _ in }) {
        withAnimation {
            let context = container.viewContext
            
            context.delete(object)
            save(completion: completion)
        }

    }
     */
}
