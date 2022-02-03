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
    static let topViewOffsetSpacing = CGFloat(95)
    static let verticalSpacing = CGFloat(25)
//    static let placeholderMeal = "Placeholder"
//    static let placeholderImage = Image(UI.placeholderMeal).resizable()

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
    case oneCategory = "Select One Category"
    case oneIngredient = "Select One Ingredient"
    case customFilter = "Customized Filter"
    
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
    case mealInfo = "Meal Information"
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
//    case welcome = "Welcome to Meal Ideas!\n\nTo get started: \nTap Surprise me for a Random meal\n\n Or type in a keyword in the search bar \n\n Or click the filter button for Category, Ingredient, or custom filters of the three"
    case welcome = "Welcome to Meal Ideas!"
    case noMealsMyIdeas = "No meals found for your search. \n You can create a new one to match this search \nby tapping the edit icon at the top left."
    case noIngredient = "No meals have been created that contain ingredients."
    case noCategory = "No meals have been created that contain any categories."
    case noMealsFound = "No meals found for your search"
    case tapToCreate = "Tap the + to create a meal"
    case noFavorites = "No favorites saved yet"
    case noHistory = "No meals viewed"

}


enum ImageNames: String{
    case placeholderMeal = "Placeholder"
    case createMealImage = "CreateAMealImage"
    case filterMenuImage = "FilterMenuImage"
    case createAMealShort = "CreateAMealShort"
    case adaptiveFilterImage = "AdaptiveFilterImage"
    case tabBarImage = "TabBarImage"
    case topViewEditHighlightImage = "TopViewEditHighlightImage"
    case addCustomItemImage = "AddCustomItemImage"
    case topViewFavoritesHighlighted = "TopViewFavoritesHighlighted"
    case myIdeasList = "MyIdeasList"
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

//    static let spoonCategories = "https://api.spoonacular.com/recipes/complexSearch?" + APIKey.spoon + "&number=10&addRecipeInformation=true&fillIngredients=true&type="
//
//    static let spoonIngredients = "https://api.spoonacular.com/recipes/complexSearch?" + APIKey.spoon + "&number=10&addRecipeInformation=true&fillIngredients=true&includeIngredients="
//
//    static let spoonKeyword = "https://api.spoonacular.com/recipes/complexSearch?" + APIKey.spoon + "&number=10&addRecipeInformation=true&&fillIngredients=true&titleMatch="
    
    static let spoonCategories = spoonComplexBase + SpoonTags.category.rawValue
    static let spoonIngredients = spoonComplexBase + SpoonTags.ingredient.rawValue
    static let spoonKeyword = spoonComplexBase + SpoonTags.keyword.rawValue
    
    
    static let spoonSingleBase = "https://api.spoonacular.com/recipes/"
    static let SpoonSingleSuffix = "/information?includeNutrition=false" + APIKey.spoon

}
