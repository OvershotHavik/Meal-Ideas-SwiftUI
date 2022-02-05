//
//  NetworkManager.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//


import UIKit
//import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let cache = NSCache<NSString, UIImage>()
    
    //fromURLString is what the call will be, but urlString is what is used within the function
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void ){
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey){
            completed(image)
            return
        }
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                
                guard let data = data, let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
                
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            }
            task.resume()
        }

    }
    
    // MARK: - MealDB Network Calls
    func getIngredients() async throws -> [Ingredients.Meals]{
        guard let url = URL(string: BaseURL.ingredientsList) else {
            throw MIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw MIError.invalidResponse
        }
        
        do{
            let results = try JSONDecoder().decode(Ingredients.mealDBIngredients.self, from: data)
            
            return results.meals
        } catch {
            throw MIError.invalidData
        }
    }
    // MARK: - Meal DB Query
  
    func mealDBQuery(query: String, queryType: QueryType) async throws ->[MealDBResults.Meal]{
        switch queryType {
        case .none:
            //used for single meal lookup
            guard let url = URL(string: BaseURL.mealDBIndividual + query) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await mealDBNetworkCall(url: url)
            
            
        case .random:
            guard let url = URL(string: BaseURL.mealDBRandom) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await mealDBNetworkCall(url: url)
            
            
        case .category:
            guard let url = URL(string: BaseURL.mealDBCategories + query) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await mealDBNetworkCall(url: url)
            
            
        case .ingredient:
            guard let url = URL(string: BaseURL.mealDBIngredient + query) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await mealDBNetworkCall(url: url)
            
            
        case .keyword:
            guard let url = URL(string: BaseURL.mealDBKeyword + query) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await mealDBNetworkCall(url: url)
            
            
        case .custom:
            //custom not used in mealDB due to limitations in their API
            guard let url = URL(string: "" + query) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await mealDBNetworkCall(url: url)
        }
    }
// MARK: - MealDB Network Call
    func mealDBNetworkCall(url: URL) async throws -> [MealDBResults.Meal]{
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw MIError.invalidResponse
        }
        
        do{
            let results = try JSONDecoder().decode(MealDBResults.Results.self, from: data)
            
            return results.meals
        } catch {
            throw MIError.invalidData
        }
    }
    
    // MARK: - Spoon Query
    func spoonQuery(query: String, queryType: QueryType) async throws -> [SpoonacularResults.Recipe]{
        switch queryType {
        case .random:
            guard let url = URL(string: BaseURL.spoonRandom) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await spoonNetworkCall(url: url)

        default:
            guard let url = URL(string: "not Setup In spoon Query") else {
                throw MIError.invalidURL
            }
            print(url)
            print("Not setup yet in spoon query")
            return try await spoonNetworkCall(url: url)
        }
        
    }
    // MARK: - Spoon Complex Query
    func spoonComplexQuery(query: String, queryType: QueryType) async throws -> SpoonacularResults.ResultsFromComplex{
        switch queryType {

        case .category:
            guard let url = URL(string: BaseURL.spoonCategories + query) else {
                throw MIError.invalidURL
            }
            print(url)
            return try await spoonComplexQuery(url: url)
            
            
        case .ingredient:
            guard let url = URL(string: BaseURL.spoonIngredients + query) else {
                throw MIError.invalidURL
            }
            print(url)
            //Ingredients returns an array of "results" instead of "meals" that's why this is different
            return try await spoonComplexQuery(url: url)
            
            
        case .keyword:
            guard let url = URL(string: BaseURL.spoonKeyword + query) else {
                throw MIError.invalidURL
            }
            print(url)
            
            return try await spoonComplexQuery(url: url)
            
            
        case .custom:
            guard let url = URL(string: BaseURL.spoonComplexBase + query) else {
                throw MIError.invalidURL
            }
            print(url)
            
            return try await spoonComplexQuery(url: url)
            
            
        default:
            print("Not setup yet in spoon complex query")

            guard let url = URL(string: "not Setup In spoon Query") else {
                throw MIError.invalidURL
            }
            print(url)
            return try await spoonComplexQuery(url: url)
        }
    }
    
    // MARK: - Spoon Complex Search Query
    func spoonComplexQuery(url: URL) async throws -> SpoonacularResults.ResultsFromComplex{
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw MIError.invalidResponse
        }
        
        do{
            let results = try JSONDecoder().decode(SpoonacularResults.ResultsFromComplex.self, from: data)
            
            return results
        } catch {
            throw MIError.invalidData
        }
    }

    // MARK: - Spoon Single Meal
    func spoonSingleMeal(query: String) async throws -> SpoonacularResults.Recipe{
        guard let url = URL(string: BaseURL.spoonSingleBase + query + BaseURL.SpoonSingleSuffix) else {
            throw MIError.invalidURL
        }
        print(url)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw MIError.invalidResponse
        }
        
        do{
            let results = try JSONDecoder().decode(SpoonacularResults.Recipe.self, from: data)
            
            return results
        } catch {
            throw MIError.invalidData
        }
    }
    
    // MARK: - Spoon Network Call
    func spoonNetworkCall(url: URL) async throws -> [SpoonacularResults.Recipe]{
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw MIError.invalidResponse
        }
        
        do{
            let results = try JSONDecoder().decode(SpoonacularResults.DataResults.self, from: data)
            
            return results.recipes
        } catch {
            throw MIError.invalidData
        }
    }


}

