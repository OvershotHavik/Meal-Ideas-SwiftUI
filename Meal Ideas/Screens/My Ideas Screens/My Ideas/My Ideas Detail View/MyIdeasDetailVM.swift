//
//  MyIdeasDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

final class MyIdeasDetailVM: DetailBaseVM{
    
    @Published var meal: UserMeals?
    @Published var instructionsPhoto = UIImage()
    
    
    init(meal: UserMeals?, favorited: Bool, showingHistory: Bool){
        self.meal = meal
        super.init()
        self.favorited = favorited
        self.showingHistory = showingHistory
        addToHistory()
    }


    func favoriteToggled(){
        if favorited == true {
            //add to favorites
            if let safeMeal = meal{
                PersistenceController.shared.saveFavorites(mealName: safeMeal.mealName ?? "",
                                                           mealDBID: nil,
                                                           spoonID: nil,
                                                           userMealID: safeMeal.userMealID)
                print("add to favorite")
            }
        } else {
            //remove from favorite
            if let safeMeal = meal {
                PersistenceController.shared.deleteFavorite(source: .mealDB,
                                                            mealName: safeMeal.mealName ?? "",
                                                            mealDBID: nil,
                                                            spoonID: nil,
                                                            userMealID: safeMeal.userMealID)
                print("remove from favorites")
            }
        }
    }


    func addToHistory(){
        //Only add to history if not already showing the meal in history list
        if showingHistory == false{
            if meal != nil{
                //only add it once the meal is set, otherwise it's just a blank name and id
                print("Added meal to history: \(meal?.mealName ?? "")")
                PersistenceController.shared.addToHistory(mealName: meal?.mealName ?? "",
                                                          mealDBID: nil,
                                                          spoonID: 0,
                                                          userMealID: meal?.userMealID)
            }
        }
    }
    
    
    func shareTapped(){
        guard let meal = meal else {
            return
        }
        var mealPhoto: UIImage?
        var instructionPhoto: UIImage?
        var sharedString = ""
        
        sharedString = "\(meal.mealName ?? "")\n\n"
        
        var prepTime = ""
        if meal.prepHour != 0{
            prepTime += "\(meal.prepHour)h "
        }
        if meal.prepMinute != 0{
            prepTime += "\(meal.prepMinute)m "
        }
        if meal.prepSecond != 0{
            prepTime += "\(meal.prepSecond)s "
        }
        if prepTime != ""{
            sharedString += "Prep Time: \(prepTime)\n\n"
        }
        if let categories = meal.category as? [String]{
            if !categories.isEmpty{
                sharedString += "Categories: "
                for category in categories {
                    sharedString += "\(category), "
                }
                sharedString.removeLast(2)
                sharedString += "\n\n"
            }
        }

        if let sides = meal.sides as? [String]{
            if !sides.isEmpty{
                sharedString += "Sides: "
                for side in sides {
                    sharedString += "\(side), "
                }
                sharedString.removeLast(2)
                sharedString += "\n\n"
            }
        }
        
        if let ingredients = meal.ingredients as? [String],
            let measurements = meal.measurements as? [String]{
            if !ingredients.isEmpty{
                sharedString += "Ingredients: \n"
                for i in ingredients.indices{
                    if measurements[i] != ""{
                        sharedString += "\(ingredients[i]) - \(measurements[i])\n"
                    } else {
                        sharedString += "\(ingredients[i])\n"
                    }
                }
                sharedString += "\n\n"
            }
        }
        if let safeRecipe = meal.recipe{
            sharedString += "Recipe:\n\(safeRecipe)\n\n"
        }
        
        if let safeSource = meal.source{
            if safeSource != ""{
                sharedString += "Website: \(safeSource)\n\n"
            }
        }
        print(sharedString)
        if let safeMealPhoto = meal.mealPhoto{
            mealPhoto = UIImage(data: safeMealPhoto)
        }
        if let safeInstructions = meal.instructionsPhoto{
            instructionPhoto = UIImage(data: safeInstructions)
        }
        
        presentShareAS(sharedString: sharedString,
                       mealPhoto: mealPhoto,
                       instructionsPhoto: instructionPhoto)
    }
    
    
    func presentShareAS(sharedString: String?, mealPhoto: UIImage?, instructionsPhoto: UIImage?){
        isShareSheetShowing.toggle()
        var activityItems: [Any] = []
        if let safeString = sharedString{
            activityItems.append(safeString)
        }
        if let safeMealPhoto = mealPhoto{
            activityItems.append(safeMealPhoto)
        }
        if let safeInstructionsPhoto = instructionsPhoto{
            activityItems.append(safeInstructionsPhoto)
        }
        let shareActionSheet = UIActivityViewController(activityItems: activityItems,  applicationActivities: nil)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(shareActionSheet, animated: true, completion: nil)
    }
}
