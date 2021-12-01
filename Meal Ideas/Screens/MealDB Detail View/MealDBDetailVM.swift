//
//  MealDBDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation

final class MealDBDetailVM: ObservableObject{
    @Published var meal: MealDBResults.Meal
    
    init(meal : MealDBResults.Meal){
        self.meal = meal
    }
    
    
}
