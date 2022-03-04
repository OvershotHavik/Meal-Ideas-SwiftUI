//
//  Constants.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/6/21.
//

import UIKit
import SwiftUI


enum UI{
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
    case mealDB = "The MealDB"
    case spoonacular = "Spoonacular"
    case shoppingList = "Shopping List"
    case settings = "Settings"

    case misc = "Misc. Ingredients"
    case history = "History"
    case favorites = "Favorites"
    
    case editCategories = "Edit Categories"
    case editIngredients = "Edit Ingredients"
    case editSides = "Edit Sides"
    
    case multiCategory = "Select Categories"
    case multiIngredients = "Select Ingredients"
    case multiSides = "Select Sides"
    
    case spoonFavorite = "Spoonacular Favorites"
    case mealDBFavorite = "The Meal DB Favorites"
    case myIdeasFavorite = "My Ideas Favorites"
    
    case spoonHistory = "Spoonacular History"
    case mealDBHistory = "The Meal DB History"
    case myIdeasHistory = "My Ideas History"
}


enum Misc: String{
    case mealName = "misc"
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
    case noMealsMyIdeas = "No meals found for your search. \n You can create a new meal to match this search by tapping the edit icon at the top left."
    case noIngredient = "No meals have been created that contain ingredients."
    case noCategory = "No meals have been created that contain any categories."
    case noMealsFound = "No meals found for your search."
    case tapToCreate = "Tap the + to create a meal."
    case noFavorites = "No favorites saved yet."
    case noHistory = "No meals viewed."
    case addToShoppingList = "Tap an ingredient to add it to the shopping list."
    case noShoppingList = "Tap on ingredients in meals to add them to your shopping list."
    case allResultsShown = "All results shown for this search"
}


enum ShoppingListMessage: String{
    case add = "Added to the Shopping List tab."
    case remove = " Removed from the Shopping List tab."
}


enum ImageNames: String{
    case placeholderMeal = "Placeholder"
    case filterMenuImage = "FilterMenuImage"
    
    //Onboarding
    case adaptiveFilterImage = "AdaptiveFilterImage"
    case tabBarImage = "TabBarImage"
    case topViewEditHighlightImage = "TopViewEditHighlightImage"
    case addCustomItemImage = "AddCustomItemImage"
    case topViewFavoritesHighlighted = "TopViewFavoritesHighlighted"
    case myIdeasList = "MyIdeasList"
    case createAMealImage = "CreateAMealImage"
    
    //shopping List Onboarding
    case SLAdd = "SLAdd"
    case SLRemove = "SLRemoveChecked"
    case SLSearchable = "SLSearchable"
    case SLSeparation = "SLSeparation"
    case SLMisc = "SLMisc"
}

enum SFSymbols: String{
    case iCloud = "person.icloud.fill"
    case list = "list.dash"
    case settings = "gearshape.fill"
    case source = "fork.knife.circle.fill"
    case person = "person"
    case filter = "slider.horizontal.3"
    
    case favorited = "heart.fill"
    case unFavorited = "heart"
    case history = "book"
    
    case check = "checkmark"
    case timer = "timer"
    case personFilled = "person.fill"
    
    case chevronRight = "chevron.right"
    case share = "square.and.arrow.up"
    case plus = "plus"
    case trash = "trash"
    case edit = "square.and.pencil"
    case chevronLeft = "chevron.left"
}

/*
//Uncomment this section to clear the alerts. The network calls will not work but the app can be used for user meals
final class APIKey{
    static let spoon = ""
    static let mealDB = ""
    
}
*/


enum BaseURL{
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


enum OnboardingTitles: String{
    //Original onboarding
    case welcome = "Welcome to Meal Ideas!"
    case myIdeasList = "Your Ideas"
    case createYourFirst = "Create Your Meal Idea"
    case addCustom = "Add Custom Items"
    case searchForIdeas = "Searching for Ideas"
    case adaptiveFilter = "Adaptive Filters"
    case additionalSources = "Additional Sources"
    case favoritesAndHistory = "Favorites and History"
    case shoppingList = "Shopping List"
    case cloudKitEnabled = "Sync Across Devices"
    
    //Shopping List
    case onceAdded = "Add Ingredients"
    case mealSeparation = "Meal Separation"
    case searchable = "Search Across All Meals"
    case clearingList = "Clear Shopping List"
    case miscItems = "Misc Items"
}


enum OnboardingSecondary: String{
    //Original Onboarding
    case welcome = "To get to your meals, use the Edit button at the top left."
    case myIdeasList = "Here is where you can select a meal to edit. \n\nTap the + to create a new meal."
    case createYourFirst = "Here you will be able to fill in the information for your meal. \n\nThe only thing that is required is the meal name. \n\nHowever, the more you add the better the filters will work."
    case addCustom = "Not seeing a category, ingredient, or side you want? \n\nTap the + to add your own custom ones! \n\nThese can be edited in the Settings tab."
    case searchForIdeas = "Tap Surprise Me for a random meal. \n\nOr search by keyword in the text field. \n\nOr tap the filter icon to get more options."
    case adaptiveFilter = "For My Ideas only: \nThe filters will only show choices for ingredients or categories for meals that have been created with them. \n\nThe other sources only list categories that are supported by them."
    case additionalSources = "Not sure what to make? \n\nNeed some more inspiration? \n\nYou can search other sources! \n\nWhichever search type you select will cary over to the other sources automatically."
    case favoritesAndHistory = "Each source keeps track of the meals you have viewed, along with favorited meals. \n\nThese can be viewed here."
    case shoppingList = "You can tap ingredients to add them to the Shopping List. \n\nTap the Shopping List Tab to learn more."
    case cloudKitEnabled = "Any meals you create, custom items, shopping list, favorites and history for each source is synced across your iPhone and iPad devices."
    
    //Shopping List
    case shoppingListIntro = "You can now select ingredients from meals and store them in the shopping list tab."
    case onceAdded = "When you tap an ingredient in the list, it will show a check mark. \n\nIt will remain checked until you either tap it again to remove it, or remove it from the shopping list."
    case mealSeparation = "Each meal will get it's own section as you add ingredients from different meals."
    case searchable = "You can pull down to search for an ingredient. \n\nIf the meal contains the ingredient, it will show it. \n\nOtherwise the meal won't show any ingredients below the title."
    case clearingList = "You can check off items as you pick them up. \n\nAt the top of the screen either tap the \"Remove Checked\" or \"Clear All\" buttons."
    case shoppingCloudKitEnabled = "Your shopping list will be synced across your iPhone and iPad devices."
    case miscItems = "You can also tap Add Misc Items and add ingredients you haven't selected from meals. \n\nThis way you can just look in one place for all your shopping items."
}
