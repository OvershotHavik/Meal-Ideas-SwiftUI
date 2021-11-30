//
//  MyMealModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import Foundation
import SwiftUI

struct UserMealModel: Codable, Equatable, Identifiable{
    var id = UUID()
    var mealName : String
    var mealPhoto: Data?
    var category : [String]
    var ingredients: [String]
    var sides : [String]
    var source: String
    var instructionsPhoto: Data?
    var recipe: String
    var favorite = false
    var measurements: [String]
}

struct UserIngredient: Identifiable{
    var id = UUID()
    var name: String
    var measurement: String
}

struct Blank{
    static let userMeal = UserMealModel(mealName: "",
                                        mealPhoto: nil,
                                        category: [],
                                        ingredients: [],
                                        sides: [],
                                        source: "",
                                        instructionsPhoto: nil,
                                        recipe: "",
                                        measurements: [])
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
                                                    mealName: "Pizza extra long name to see how it wraps in the view accordingly ",
                                                    mealPhoto: "Pizza",
                                                    category: ["Dinner", "Lunch"],
                                                    ingredients: ["Frozen Food", "Cheese", "Pepperoni"],
                                                    sides: ["Garlic Bread", "French Fries"],
                                                    source: "https://www.thekitchn.com/how-to-make-really-good-pizza-at-home-cooking-lessons-from-the-kitchn-178384",
                                                    instructionsPhoto: "Pizza-Instructions",
                                                    recipe: "Preheat oven to 400, set timmer for 21 min",
                                                    favorite: true,
                                                    measurements: ["1", "2 cups", "15"])
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
    
    static let testUserArray = [userMealSample, userMealSample2, userMealSample3, userMealSample4]
}
