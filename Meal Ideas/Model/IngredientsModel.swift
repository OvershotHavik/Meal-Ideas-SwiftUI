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
    struct Meals: Decodable, Identifiable{
//        var id: ObjectIdentifier
        enum CodingKeys: String, CodingKey{
            case idIngredient, strIngredient, strDescription, strType
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .idIngredient)
            strIngredient = try container.decode(String.self, forKey: .strIngredient)
            strDescription = try container.decodeIfPresent(String.self, forKey: .strDescription)
            strType = try container.decodeIfPresent(String.self, forKey: .strType)
        }
        

        
        var id: String
//        var idIngredient: String
        var strIngredient: String
        var strDescription: String?
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
