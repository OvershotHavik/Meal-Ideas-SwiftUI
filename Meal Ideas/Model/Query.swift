//
//  Query.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
enum QueryType: String{
    case random = "Random"
    case category = "Category"
    case ingredient = "Ingredient"
    case history = "book"
    case favorite = "heart.fill"
}

final class Query: ObservableObject{
    @Published var query = QueryType.random
    @Published var selected : String?
}
