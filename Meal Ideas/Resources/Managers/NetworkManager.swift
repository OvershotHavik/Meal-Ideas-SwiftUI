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
            
        default:
            print("Query Type not setup in MealDBQuery yet")
            guard let url = URL(string: "https://www.google.com") else {
                throw MIError.invalidURL
            }
            print(url)
            return try await mealDBNetworkCall(url: url)
        }
//        case .ingredient:
//            ()
//        case .history:
//            ()
//        case .favorite:
//            ()
//        case .none:
//            ()
        
    }
    /*
Original random meal
    func mealDBRandom() async throws -> [MealDBResults.Meal]{
        guard let url = URL(string: BaseURL.mealDBRandom) else {
            throw MIError.invalidURL
        }
        print(url)
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
    */
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
}


