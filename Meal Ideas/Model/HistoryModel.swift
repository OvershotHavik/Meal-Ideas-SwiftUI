//
//  HistoryModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import Foundation

class History: Codable{
    var mealName = String()
    var mealDBID : String?
    var spoonID: Int?
    var timeStamp : Date?
    var favorited = Bool()
}

class UserHistory: Codable{
    struct Meal: Codable{
        var mealName : String
    }
}
