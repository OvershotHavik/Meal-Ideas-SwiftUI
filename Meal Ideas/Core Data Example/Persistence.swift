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

    //Just used for preview of the example pre built, will delete later
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

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
}
