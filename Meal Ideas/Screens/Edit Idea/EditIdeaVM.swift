//
//  EditIdeaVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

final class EditIdeaVM: ObservableObject{
    @Published var meal : UserMealModel?
    @Published var alertItem: AlertItem?
    
    @Published var mealPhoto : UIImage?
    @Published var mealName = ""
    @Published var categories: [String] = []
    @Published var userIngredients : [UserIngredient] = []
    @Published var recipe = ""
    @Published var instructionsPhoto : UIImage?
    @Published var sides : [String] = []
    @Published var source = ""
    @Published var favorited = false
    

    init(meal: UserMealModel?){
        self.meal = meal
    }
    
    // MARK: - Remove Category
    func deleteCat(at offsets: IndexSet){
        categories.remove(atOffsets: offsets)
    }
    // MARK: - Remove Ingredient
    func deleteIngredient(at offsets: IndexSet){
        userIngredients.remove(atOffsets: offsets)
    }
    // MARK: - Remove Sides
    func deleteSide(at offsets: IndexSet){
        sides.remove(atOffsets: offsets)
    }
    
    
    
    // MARK: - Save Meal
    func saveMeal(){
        print("Save meal...")
        var mealPhotoData: Data?
        if let safePhoto = mealPhoto{
            mealPhotoData = safePhoto.jpegData(compressionQuality: 1.0)
        }
        
        var instructionsPhotoData: Data?
        if let safePhoto = instructionsPhoto{
            instructionsPhotoData = safePhoto.jpegData(compressionQuality: 1.0)
        }
        
        var ingredients : [String] = []
        var measurements : [String] = []
        
        userIngredients = userIngredients.sorted {$0.name < $1.name}
        for x in userIngredients{
            ingredients.append(x.name)
            measurements.append(x.measurement)
        }
        
        
        let newMeal = UserMealModel(mealName: mealName,
                                    mealPhoto: mealPhotoData,
                                    category: categories,
                                    ingredients: ingredients,
                                    sides: sides,
                                    source: source,
                                    instructionsPhoto: instructionsPhotoData,
                                    recipe: recipe,
                                    favorite: favorited,
                                    measurements: measurements)
        print(newMeal)
        // TODO:  save meal to core data
    }
    // MARK: - Delete Meal
    func deleteMeal(){
        print("Delete meal...")
        // TODO:  delete the meal from core data
    }
    
    // MARK: - Convert meal to values to be able to modify it
    func convertMeal(){
        guard let safeMeal = meal else {
            return
        }
        self.mealName = safeMeal.mealName
        
        if let safeMealPhotoData = safeMeal.mealPhoto{
            self.mealPhoto = UIImage(data: safeMealPhotoData)
        }
        
        self.categories = safeMeal.category
        
        for (index, _) in safeMeal.ingredients.enumerated(){
            let UserIngredient = UserIngredient(name: safeMeal.ingredients[index],
                                                measurement: safeMeal.measurements[index])
            self.userIngredients.append(UserIngredient)
        }
        
        if let safeInstructionsData = safeMeal.instructionsPhoto{
            self.instructionsPhoto = UIImage(data: safeInstructionsData)
        }
        self.recipe = safeMeal.recipe
        
        self.sides = safeMeal.sides
        self.source = safeMeal.source
        
    }
}