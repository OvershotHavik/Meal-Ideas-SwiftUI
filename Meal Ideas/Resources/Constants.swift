//
//  Constants.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/6/21.
//

import UIKit
import SwiftUI

final class Constants{
//    static let 
}

class UI{
    static let horizontalSpacing = CGFloat(12)
    static let verticalSpacing = CGFloat(8)
    static let cornerRadius = CGFloat(12)
    static let backgroundColor = UIColor.systemGray5
    static let closeButtonImage = "xmark"
    static let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
    static let mediumConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .medium)
    static let createImagePlaceholder = UIImage(systemName: "camera.on.rectangle")

}
enum PList: String{
    case categories = "Categories"
    case mealDBFavorites = "mealDBFavorites"
    case spoonFavorites = "spoonFavorites"
    case mealDBHistory = "mealDBHistory"
    case spoonHistory = "spoonHistory"
    case userSides = "userSides"
    case userIngredients = "userIngredients"
    case userHistory = "userHistory"
    case sides = "Sides"
    case userCat = "UserCategories"
}

enum Source: String{
    case spoonacular = "Spoonacular"
    case mealDB = "MealDB"
//    case user = "User"
}

enum Titles: String{
    case oneCategory = "Select One Category"
    case oneIngredient = "Select One Ingredient"
    
    case multiCategory = "Select Categories"
    case multiIngredients = "Select Ingredients"
    case multiSides = "Select Sides"
}
