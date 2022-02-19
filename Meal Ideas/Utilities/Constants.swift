//
//  Constants.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/6/21.
//

import UIKit
import SwiftUI


class UI{
    static let topViewOffsetSpacing = CGFloat(95)
    static let verticalSpacing = CGFloat(25)
}
enum PList: String{
    case categories = "Categories"
    case spoonCategories = "SpoonCategories"
    case mealDBCategories = "MealDBCategories"
    case sides = "Sides"
}

enum EntityName: String{
    case userMeals = "UserMeals"
    case history = "History"
    case favorites = "Favorites"
    case CDIngredient = "CDIngredient"
    case CDCategory = "CDCategory"
    case CDSides = "CDSides"
    case ShoppingList = "ShoppingList"
}

enum ListType: String{
    case side = "Side"
    case ingredient = "Ingredient"
    case category = "Category"
}

enum Source: String{
    case spoonacular = "Spoonacular"
    case mealDB = "MealDB"
    case myIdeas = "MyIdeas"
}

enum Titles: String{
    case mainTitle = "Meal Ideas"
    case oneCategory = "Categories"
    case oneIngredient = "Ingredients"
    case customFilter = "Custom Filter"
    
    case myIdeas = "My Ideas"
    case history = "History"
    case favorites = "Favorites"
    
    case settings = "Settings"
    case editCategories = "Edit Categories"
    case editIngredients = "Edit Ingredients"
    case editSides = "Edit Sides"
    
    
    case multiCategory = "Select Categories"
    case multiIngredients = "Select Ingredients"
    case multiSides = "Select Sides"
    
    case spoonFavorite = "Favorites from Spoonacular"
    case mealDBFavorite = "Favorites from The Meal DB"
    case myIdeasFavorite = "Favorites from My Ideas"
    
    case spoonHistory = "History from Spoonacular"
    case mealDBHistory = "History from The Meal DB"
    case myIdeasHistory = "History from My Ideas"
}

enum SpoonTags: String{
    case category = "&type="
    case ingredient = "&includeIngredients="
    case keyword = "&titleMatch="
}


enum SectionHeaders: String{
    //Edit Meal
    case mealInfo = "Meal Name and Photo"
    case category = "Category"
    case ingredients = "Ingredients"
    case sides = "Sides"
    case prep = "Prep Time"
    case instructions = "Instructions / Recipe"
    case source = "Source"
    case modified = "Modified Dates"
    
    //Custom Filter
    case none = "No Filter"
}

enum Messages: String{
    case welcome = "Welcome to Meal Ideas!"
    case noMealsMyIdeas = "No meals found for your search. \n You can create a new one to match this search by tapping the edit icon at the top left."
    case noIngredient = "No meals have been created that contain ingredients."
    case noCategory = "No meals have been created that contain any categories."
    case noMealsFound = "No meals found for your search"
    case tapToCreate = "Tap the + to create a meal"
    case noFavorites = "No favorites saved yet"
    case noHistory = "No meals viewed"
    case shareIngredient = "Tap an ingredient to add it to a list to share"

}


enum ImageNames: String{
    case placeholderMeal = "Placeholder"
    case filterMenuImage = "FilterMenuImage"
    case adaptiveFilterImage = "AdaptiveFilterImage"
    case tabBarImage = "TabBarImage"
    case topViewEditHighlightImage = "TopViewEditHighlightImage"
    case addCustomItemImage = "AddCustomItemImage"
    case topViewFavoritesHighlighted = "TopViewFavoritesHighlighted"
    case myIdeasList = "MyIdeasList"
    case createAMealImage = "CreateAMealImage"
}
/*
//Uncomment this section to clear the alerts. The network calls will not work but the app can be used for user meals
final class APIKey{
    static let spoon = ""
    static let mealDB = ""
    
}
*/
final class BaseURL{
    static let ingredientsList = "https://www.themealdb.com/api/json/v1/1/list.php?i=list"
    static let ingredientImage = "https://www.themealdb.com/images/ingredients/"

//    static let mealDBRandom = APIKey.mealDB + "randomselection.php" // 10 meals in one call
    static let mealDBRandom = "https://www.themealdb.com/api/json/v1/1/random.php" // single meal
    static let mealDBCategories = APIKey.mealDB + "filter.php?c="
    static let mealDBIndividual = APIKey.mealDB + "lookup.php?i="
    static let mealDBIngredient = APIKey.mealDB + "filter.php?i="
    static let mealDBKeyword = APIKey.mealDB + "search.php?s="
    
    static let spoonComplexBase = "https://api.spoonacular.com/recipes/complexSearch?" + APIKey.spoon + "&number=15&addRecipeInformation=true&fillIngredients=true"
    
    static let spoonRandom = "https://api.spoonacular.com/recipes/random?number=1" + APIKey.spoon

    
    static let spoonCategories = spoonComplexBase + SpoonTags.category.rawValue
    static let spoonIngredients = spoonComplexBase + SpoonTags.ingredient.rawValue
    static let spoonKeyword = spoonComplexBase + SpoonTags.keyword.rawValue
    
    
    static let spoonSingleBase = "https://api.spoonacular.com/recipes/"
    static let SpoonSingleSuffix = "/information?includeNutrition=false" + APIKey.spoon
}
