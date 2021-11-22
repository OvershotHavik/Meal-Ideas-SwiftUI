//
//  MyMealModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import Foundation

struct UserMealModel: Codable, Equatable, Identifiable{
    var id = UUID()
    var mealName : String
    var mealPhoto: Data?
    var category : [String]
    var ingredients: [String]
    var sides : [String]
    var source: String?
    var instructionsPhoto: Data?
    var recipe: String
    var favorite = false
    var measurements: [String]?
}



// For UI setup only
struct SampleUserMealModel: Codable, Equatable, Identifiable{
    var id = UUID()
    var mealName : String
    var mealPhoto: String // use string to identify the image in assets
    var category : [String]
    var ingredients: [String]
    var sides : [String]
    var source: String?
    var instructionsPhoto: String // use string to identify the image in assets
    var recipe: String
    var favorite = false
    var measurements: [String]?
}
struct UserResults: Codable{
    let meals : [UserMealModel]
}

struct MockData{
//    static let userMealSample = SampleUserMealModel
    static let userMealSample = SampleUserMealModel(id: UUID(),
                                                    mealName: "Pizza",
                                                    mealPhoto: "Pizza",
                                                    category: ["Dinner", "Lunch"],
                                                    ingredients: ["Frozen Food"],
                                                    sides: ["Garlic Bread", "French Fries"],
                                                    source: "https://www.thekitchn.com/how-to-make-really-good-pizza-at-home-cooking-lessons-from-the-kitchn-178384",
                                                    instructionsPhoto: "Pizza-Instructions",
                                                    recipe: "Preheat oven to 400, set timmer for 21 min",
                                                    favorite: true,
                                                    measurements: ["1"])
    
}
