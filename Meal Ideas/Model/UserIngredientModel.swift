//
//  MyMealModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct UserIngredient: Identifiable, Equatable{
    var id = UUID()
    var name: String
    var measurement: String
}
