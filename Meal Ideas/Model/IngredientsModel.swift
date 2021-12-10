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
    struct mealDBIngredients: Decodable{
        var meals : [Meals]
    }
    class Meals: Codable, Identifiable, Equatable{

        static func == (lhs: Ingredients.Meals, rhs: Ingredients.Meals) -> Bool {
            return lhs.id == rhs.id &&
            lhs.strIngredient == rhs.strIngredient &&
            lhs.strDescription == rhs.strDescription &&
            lhs.strMeasurement == rhs.strMeasurement &&
            lhs.strType == rhs.strType
        }
        
        enum CodingKeys: String, CodingKey{
            case idIngredient, strIngredient, strDescription, strType
        }
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .idIngredient)
            strIngredient = try container.decode(String.self, forKey: .strIngredient)
            strMeasurement = try container.decode(String.self, forKey: .strIngredient)
            strDescription = try container.decodeIfPresent(String.self, forKey: .strDescription)
            strType = try container.decodeIfPresent(String.self, forKey: .strType)
        }
        
        private enum Base: String, Codable {
            case id, strIngredient, strMeasurement, strType
        }

        func encode(to encoder: Encoder) throws {
            var c = encoder.container(keyedBy: CodingKeys.self)
            try c.encode(id, forKey: .idIngredient)
            try c.encode(strIngredient, forKey: .strIngredient)
            try c.encode(strMeasurement, forKey: .strDescription)
            try c.encode(strType, forKey: .strType)
        }
        
        var id: String
//        var idIngredient: String
        var strIngredient: String
        var strDescription: String?
        var strMeasurement: String
        var strType: String?
    }
    struct SpoonacularIngredient: Codable {
        var name : String
        var imageID : String
    }
}
//used for custom ingredients/categories/sides
struct NewItem: Codable, Hashable{
    var itemName = String()
}
