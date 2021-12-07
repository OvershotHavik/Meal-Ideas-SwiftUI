//
//  EditMealsListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI
import CoreData

// TODO:  Try moving most of these functions to the persistence file so they can be used throughout via the singleton

// TODO:  Keep this setup though so I can easily delete the meals while testing the rest for now


final class EditMealsListVM: ObservableObject{
    @Published var savedMeals: [UserMeals] = []
    @Published var TextFieldText: String = ""
    private let pc = PersistenceController.shared
    init() {
        fetchMeals()
    }
    
    
    func fetchMeals(){
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        do {
            savedMeals = try pc.container.viewContext.fetch(request)
            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    /*
    //in vm for edit meals
    func addMeal(Text: String){
        let newMeal = UserMeals(context: pc.container.viewContext)
        newMeal.mealName = Text
        saveData()
        TextFieldText = ""
    }
    //could be in PC?
    //moved to PC
    
    func saveData(){
        do{
            try pc.container.viewContext.save()
            // save it, then fetch for the meals again to update the view
            fetchMeals()
        } catch let error{
            print("error saving meals to core data: \(error.localizedDescription)")
        }
    }
    //could be in PC? would have to get the meals from the fetch though..
    func deleteMeal(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let meal = savedMeals[index]
        pc.container.viewContext.delete(meal)
        saveData()
    }
    //in vm
    
    func updateMeal(meal: UserMeals){
        let currentName = meal.mealName ?? ""
        let newName = currentName + "!"
        meal.mealName = newName
        saveData()
    }
     */
}
