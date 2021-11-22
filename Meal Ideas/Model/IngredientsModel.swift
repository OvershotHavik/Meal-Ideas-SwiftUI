//
//  IngredientsModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct ListOfItems{
    static var title = [String]()
    static var image = [Image]()
}
struct Ingredients: Codable{
    struct mealDBIngredients: Codable{
        var meals : [Meals]
    }
    struct Meals: Codable{
        var idIngredient: String
        var strIngredient: String
        var strDescription: String?
        var strType: String?
    }
    struct SpoonacularIngredient: Codable {
        var name : String
        var imageID : String
    }
}
class NewItem: Codable{
    var itemName = String()
}
