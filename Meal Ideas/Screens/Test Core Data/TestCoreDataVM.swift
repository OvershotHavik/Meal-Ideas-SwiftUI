//
//  TestCoreDataVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI
import CoreData

// TODO:  Try moving most of these functions to the persistence file so they can be used throughout via the singleton

// TODO:  Keep this setup though so I can easily delete the meals while testing the rest for now


final class TestCoreDataVM: ObservableObject{
    @Published var savedMeals: [UserMeals] = []
    @Published var TextFieldText: String = ""
    
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "Meal_Ideas")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error loading core data. \(error.localizedDescription)")
            } else {
                print("Successfully loaded core data!")
            }
        }
        fetchMeals()
    }

    func fetchMeals(){
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        do {
            savedMeals = try container.viewContext.fetch(request)
            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    func addMeal(Text: String){
        let newMeal = UserMeals(context: container.viewContext)
        newMeal.mealName = Text
        saveData()
        TextFieldText = ""
    }
    
    func saveData(){
        do{
            try container.viewContext.save()
            // save it, then fetch for the meals again to update the view
            fetchMeals()
        } catch let error{
            print("error saving meals to core data: \(error.localizedDescription)")
        }
    }
    
    func deleteMeal(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let meal = savedMeals[index]
        container.viewContext.delete(meal)
        saveData()
    }
    
    func updateMeal(meal: UserMeals){
        let currentName = meal.mealName ?? ""
        let newName = currentName + "!"
        meal.mealName = newName
        saveData()
    }
}
