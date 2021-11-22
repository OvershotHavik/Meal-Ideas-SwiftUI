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
    var id : Int
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
    static let userMealSample = SampleUserMealModel(id: 01,
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
    static let userMealSample2 = SampleUserMealModel(id: 02,
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
    static let userMealSample3 = SampleUserMealModel(id: 03,
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
    static let userMealSample4 = SampleUserMealModel(id: 04,
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
    
    static let testUerArray = [userMealSample, userMealSample2, userMealSample3, userMealSample4]
}
