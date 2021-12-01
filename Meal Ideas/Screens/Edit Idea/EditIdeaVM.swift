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
    @Published var instructionsPhoto : UIImage?
    @Published var sides : [String] = []
    @Published var recipe = ""
    @Published var source = ""
    @Published var favorited = false
    

    init(meal: UserMealModel?){
        self.meal = meal
    }
    func saveMeal(){

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
    }
}
