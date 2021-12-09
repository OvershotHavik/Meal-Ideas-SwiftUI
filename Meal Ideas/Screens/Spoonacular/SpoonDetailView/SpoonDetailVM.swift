//
//  SpoonDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation

final class SpoonDetailVM: ObservableObject{
    @Published var meal: SpoonacularResults.Recipe
    @Published var ingredients: [String] = []
    @Published var measurements: [String] = []
    @Published var instructions: String = ""
    
    init(meal: SpoonacularResults.Recipe){
        self.meal = meal
        getIngredientsAndMeasurements()
        getInstructions()
    }
    
    func getIngredientsAndMeasurements(){
        for x in meal.extendedIngredients{
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
    
    func getInstructions(){
        //If meal has analyzed instructions, go through the array and add it tot he string
        if meal.analyzedInstructions.count > 0{
            for step in meal.analyzedInstructions{
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
            if let safeInstructions = meal.instructions{
                instructions = "Instructions:\n\(safeInstructions.withoutHtmlTags)"
            }
        }
        
        if instructions == ""{
            instructions = "No instructions provided for this recipe. Please visit the source for more information."
        }
    }
}
