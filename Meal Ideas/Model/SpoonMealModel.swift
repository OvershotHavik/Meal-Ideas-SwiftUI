//
//  SpoonMealModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import Foundation


class SpoonacularResults{
    class DataResults: Codable {
        var recipes: [Recipe]
    }
    class Recipe: Codable, Identifiable{
        var creditsText: String?
        var sourceName: String?
        var extendedIngredients: [ExtendedIngredients]
        var id : Int?
        var title: String
        var readyInMinutes: Int?
        var servings: Int?
        var sourceUrl: String?
        var image: String?
        var cuisines : [String]?
        var dishTypes: [String]?
        var diets: [String]?
        var occasions: [String]?
        var instructions: String?
        var analyzedInstructions: [AnalyzedInstructions]
    }
    
    struct AnalyzedInstructions: Codable{
        let steps : [Steps]
    }
    struct Steps: Codable{
        var number: Int?
        var step: String?
        var ingredients: [Ingredients]
    }
    struct Ingredients: Codable{
        var name: String?
    }
    
    class ExtendedIngredients: Codable, Identifiable{
        let id: Int?
        let original: String?
        let name: String?
        var amount: Double?
        var unit: String?
    }
    class ResultsFromComplex: Codable{
        let results :[Results]
        let totalResults : Int?
    }
    class Results: Recipe{
    }
}
