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
    

}

