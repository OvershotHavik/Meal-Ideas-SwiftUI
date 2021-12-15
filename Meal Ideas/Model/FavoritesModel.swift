//
//  FavoritesModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import Foundation

class FavoritesModel: Codable{
//    var id = UUID() // not sure if I need this yet or not 
    var mealName = String()
    var mealDBID : String?
    var spoonID: Int?
}
