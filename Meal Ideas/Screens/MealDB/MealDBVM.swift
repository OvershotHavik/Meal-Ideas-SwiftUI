//
//  MealDBVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import Foundation

final class MealDBVM: ObservableObject{
    @Published var meals : [MealDBResults.Meal] = []
    
    func getMeals(){
        do {
            if let data = MealDBJSON.sample.data(using: .utf8){
                let results = try JSONDecoder().decode(MealDBResults.Results.self, from: data)
                self.meals = results.meals
                for x in self.meals{
                    print(x.id ?? "")
                }
                
            }
        }catch let e {
            print(e)
        }
    }
}
