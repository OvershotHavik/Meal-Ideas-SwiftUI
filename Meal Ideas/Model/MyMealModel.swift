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

struct UserIngredient: Identifiable, Equatable{
    var id = UUID()
    var name: String
    var measurement: String
}
