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


final class BaseURL{
    static let ingredientsList = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
    static let ingredientImage = "https://www.themealdb.com/images/ingredients/"
    
    static let mealDBRandom = APIKey.mealDB + "randomselection.php"
    static let mealDBCategories = APIKey.mealDB + "filter.php?c="
    static let mealDBIndividual = APIKey.mealDB + "lookup.php?i="
    static let mealDBIngredient = APIKey.mealDB + "filter.php?i="
    static let mealDBKeyword = APIKey.mealDB + "search.php?s="
    
    static let spoonRandom = "https://api.spoonacular.com/recipes/random?number=10" + APIKey.spoon
    static let spoonCategories = "https://api.spoonacular.com/recipes/random?" + APIKey.spoon + "&number=10&tags="
    
    static let spoonIngredients = "https://api.spoonacular.com/recipes/complexSearch?" + APIKey.spoon + "&number=10&addRecipeInformation=true&fillIngredients=true&includeIngredients="
    
    static let spoonKeyword = "https://api.spoonacular.com/recipes/complexSearch?" + APIKey.spoon + "&number=10&titleMatch="
    static let spoonSingleBase = "https://api.spoonacular.com/recipes/"
    static let SpoonSingleSuffix = "/information?includeNutrition=false" + APIKey.spoon

}
