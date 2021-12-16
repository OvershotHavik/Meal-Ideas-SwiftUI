//
//  SpoonDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
import UIKit

@MainActor final class SpoonDetailVM: ObservableObject{
    @Published var meal: SpoonacularResults.Recipe?
    @Published var isLoading = false
    @Published var alertItem : AlertItem?
    @Published var mealID: Int?
    @Published var ingredients: [String] = []
    @Published var measurements: [String] = []
    @Published var instructions: String = ""
    @Published var mealPhoto = UIImage()
    @Published var favorited : Bool

    
    init(meal: SpoonacularResults.Recipe?, mealID: Int?, favorited: Bool){
        self.mealID = mealID
        self.meal = meal
        self.favorited = favorited
        getIngredientsAndMeasurements()
        getInstructions()
        getMealPhoto()
        fetchMeal()
    }
    // MARK: - Get Ingredients and Measurements
    func getIngredientsAndMeasurements(){
        guard let safeMeal = meal else {
            print("meal not set in get ingredients")
            return
        }
        for x in safeMeal.extendedIngredients{
            ingredients.append(x.name ?? "")
            if let safeAmount = x.amount,
               let safeUnit = x.unit{
                
                // Replaces the decimal version with fraction for more familiar units
                switch safeAmount{
                case 0.125:
                    measurements.append("1/8 \(safeUnit)")
                case 0.25:
                    measurements.append("1/4 \(safeUnit)")
                case 0.3333333333333333:
                    measurements.append("1/3 \(safeUnit)")
                case 0.5:
                    measurements.append("1/2 \(safeUnit)")
                case 0.6666666666666666:
                    measurements.append("2/3 \(safeUnit)")
                case 0.75:
                    measurements.append("3/4 \(safeUnit)")
                default:
                    measurements.append("\(String(format: "%g", safeAmount)) \(safeUnit)")
                }
            }
        }
    }
    // MARK: - Get Instructions
    func getInstructions(){
        guard let safeMeal = meal else {
            print("meal not set in get instructions")
            return
        }
        //If meal has analyzed instructions, go through the array and add it tot he string
        if safeMeal.analyzedInstructions.count > 0{
            for step in safeMeal.analyzedInstructions{
                for i in step.steps{
                    if let safeNumber = i.number{
                        instructions +=  "Step \(safeNumber):\n"
                    }
                    if i.ingredients.count > 0{
                        instructions += "\nIngredients For Step: \n"
                        var ingredientList = String()
                        for x in i.ingredients{
                            if let safeName = x.name{
                                ingredientList += ", \(safeName)"
                            }
                        }
                        ingredientList.removeFirst(2)
                        instructions += "\(ingredientList)\n\n"
                    }
                    if let safeStep = i.step{
                        instructions += "\(safeStep)\n\n"
                    }
                }
            }
        } else {
            //If it doesn't have the steps, and just the instructions, apply that
            if let safeInstructions = safeMeal.instructions{
                instructions = "Instructions:\n\(safeInstructions.withoutHtmlTags)"
            }
        }
        
        if instructions == ""{
            instructions = "No instructions provided for this recipe. Please visit the source for more information."
        }
    }
    // MARK: - Fetch Meal
    func fetchMeal() {
        guard let safeMealID = mealID else {
            print("no meal id in fetch meal ")
            return
        }
        print("Spoon meal ID: \(safeMealID)")
        let mealID = "\(safeMealID)"
        isLoading = true
        Task {
            do {
                meal = try await NetworkManager.shared.spoonSingleMeal(query: mealID)
                getIngredientsAndMeasurements()
                getInstructions()
                getMealPhoto()
                isLoading = false
            } catch let e{
                print(e.localizedDescription)
            }
            
        }
            
        
    }
    // MARK: - Get Meal Photo
    func getMealPhoto(){
        if meal != nil{
            NetworkManager.shared.downloadImage(fromURLString: meal?.image ?? "") { uiImage in
                guard let uiImage = uiImage else { return }
                DispatchQueue.main.async {
                    self.mealPhoto = uiImage
                }
            }
        }
    }

    func favoriteToggled(){
        if favorited == true {
            //add to favorites
            print("add to favorite")
            PersistenceController.shared.saveFavorites(mealName: meal?.title ?? "",
                                                       mealDBID: nil,
                                                       spoonID: meal?.id)
            
        } else {
            //remove from favorite
            print("remove from favorites")
            PersistenceController.shared.deleteFavorite(source: .spoonacular,
                                                        mealName: meal?.title ?? "",
                                                        mealDBID: nil,
                                                        spoonID: Double(meal?.id ?? 0))
            
            
            PersistenceController.shared.deleteFavorite(source: .spoonacular,
                                                        mealName: meal?.title ?? "",
                                                        mealDBID: nil,
                                                        spoonID: Double(meal?.id ?? 0))
        }
    }
}
