//
//  MealDBModel.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import Foundation

struct MealDBResults {
    struct Results: Decodable  {
        let meals: [Meal]
    }
    struct Meal: Decodable, Identifiable, Hashable{
        enum CodingKeys: String, CodingKey{
            case idMeal, strMeal, strDrinkAlternative, strCategory, strArea, strInstructions, strMealThumb,
            strTags, strYoutube, strSource,
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20,
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        }

        init(from decoder: Decoder) throws{
            favorited = false
            var ingredientArray = [String]()
            var measureArray = [String]()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decodeIfPresent(String.self, forKey: .idMeal)
            strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
            strDrinkAlternative = try container.decodeIfPresent(String.self, forKey: .strDrinkAlternative)
            strCategory = try container.decodeIfPresent(String.self, forKey: .strCategory)
            strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
            strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
            strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
            strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
            strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
            strSource = try container.decodeIfPresent(String.self, forKey: .strSource)

            if let ingredient1 = try container.decodeIfPresent(String.self, forKey: .strIngredient1){
                ingredientArray.append(ingredient1)
            }
            if let ingredient2 = try container.decodeIfPresent(String.self, forKey: .strIngredient2){
                ingredientArray.append(ingredient2)
            }
            if let ingredient3 = try container.decodeIfPresent(String.self, forKey: .strIngredient3){
                ingredientArray.append(ingredient3)
            }
            if let ingredient4 = try container.decodeIfPresent(String.self, forKey: .strIngredient4){
                ingredientArray.append(ingredient4)
            }
            if let ingredient5 = try container.decodeIfPresent(String.self, forKey: .strIngredient5){
                ingredientArray.append(ingredient5)
            }
            if let ingredient6 = try container.decodeIfPresent(String.self, forKey: .strIngredient6){
                ingredientArray.append(ingredient6)
            }
            if let ingredient7 = try container.decodeIfPresent(String.self, forKey: .strIngredient7){
                ingredientArray.append(ingredient7)
            }
            if let ingredient8 = try container.decodeIfPresent(String.self, forKey: .strIngredient8){
                ingredientArray.append(ingredient8)
            }
            if let ingredient9 = try container.decodeIfPresent(String.self, forKey: .strIngredient9){
                ingredientArray.append(ingredient9)
            }
            if let ingredient10 = try container.decodeIfPresent(String.self, forKey: .strIngredient10){
                ingredientArray.append(ingredient10)
            }
            if let ingredient11 = try container.decodeIfPresent(String.self, forKey: .strIngredient11){
                ingredientArray.append(ingredient11)
            }
            if let ingredient12 = try container.decodeIfPresent(String.self, forKey: .strIngredient12){
                ingredientArray.append(ingredient12)
            }
            if let ingredient13 = try container.decodeIfPresent(String.self, forKey: .strIngredient13){
                ingredientArray.append(ingredient13)
            }
            if let ingredient14 = try container.decodeIfPresent(String.self, forKey: .strIngredient14){
                ingredientArray.append(ingredient14)
            }
            if let ingredient15 = try container.decodeIfPresent(String.self, forKey: .strIngredient15){
                ingredientArray.append(ingredient15)
            }
            if let ingredient16 = try container.decodeIfPresent(String.self, forKey: .strIngredient16){
                ingredientArray.append(ingredient16)
            }
            if let ingredient17 = try container.decodeIfPresent(String.self, forKey: .strIngredient17){
                ingredientArray.append(ingredient17)
            }
            if let ingredient18 = try container.decodeIfPresent(String.self, forKey: .strIngredient18){
                ingredientArray.append(ingredient18)
            }
            if let ingredient19 = try container.decodeIfPresent(String.self, forKey: .strIngredient19){
                ingredientArray.append(ingredient19)
            }
            if let ingredient20 = try container.decodeIfPresent(String.self, forKey: .strIngredient20){
                ingredientArray.append(ingredient20)
            }
            
            ingredientArray = ingredientArray.filter {$0 != " "}
            ingredientArray = ingredientArray.filter {$0 != ""}
            ingredientsArray = ingredientArray
                        
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure1){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure2){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure3){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure4){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure5){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure6){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure7){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure8){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure9){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure10){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure11){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure12){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure13){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure14){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure15){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure16){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure17){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure18){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure19){
                measureArray.append(measure)
            }
            if let measure = try container.decodeIfPresent(String.self, forKey: .strMeasure20){
                measureArray.append(measure)
            }
//            measureArray[(ingredientArray.count-1)...] = []
            measurementsArray = measureArray
        }
        
        var id : String?
        var strMeal : String?
        var strDrinkAlternative : String?
        var strCategory : String?
        var strArea : String?
        var strInstructions : String?
        var strMealThumb : String?
        var strTags: String?
        var strYoutube: String?
        var strSource: String?
        var ingredientsArray : [String] = []
        var measurementsArray : [String] = []
        var favorited : Bool
        
        struct Ingredients: Codable{
            let strIngredient1: String?
            let strIngredient2: String?
            let strIngredient3: String?
            let strIngredient4: String?
            let strIngredient5: String?
            let strIngredient6: String?
            let strIngredient7: String?
            let strIngredient8: String?
            let strIngredient9: String?
            let strIngredient10: String?
            let strIngredient11: String?
            let strIngredient12: String?
            let strIngredient13: String?
            let strIngredient14: String?
            let strIngredient15: String?
            let strIngredient16: String?
            let strIngredient17: String?
            let strIngredient18: String?
            let strIngredient19: String?
            let strIngredient20: String?
        }
        
        struct Measurements: Codable{
            let strMeasure1: String?
            let strMeasure2: String?
            let strMeasure3: String?
            let strMeasure4: String?
            let strMeasure5: String?
            let strMeasure6: String?
            let strMeasure7: String?
            let strMeasure8: String?
            let strMeasure9: String?
            let strMeasure10: String?
            let strMeasure11: String?
            let strMeasure12: String?
            let strMeasure13: String?
            let strMeasure14: String?
            let strMeasure15: String?
            let strMeasure16: String?
            let strMeasure17: String?
            let strMeasure18: String?
            let strMeasure19: String?
            let strMeasure20: String?
        }
    }
}
