//
//  SpoonVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation

final class SpoonVM: ObservableObject{
    @Published var meals: [SpoonacularResults.Recipe] = []
    
    func getMeals(){
        do{
            if let data = SpoonJSON.sample.data(using: .utf8){
                let results = try JSONDecoder().decode(SpoonacularResults.DataResults.self, from: data)
                self.meals = results.recipes
                for x in results.recipes{
                    print(x.title)
                }
            }
        }catch let e{
            print(e)
        }
    }
}
