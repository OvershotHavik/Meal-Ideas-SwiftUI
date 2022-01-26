//
//  SettingsVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import Foundation
import CoreData

@MainActor final class SettingsVM: ObservableObject{
    @Published var test = ""
    @Published var userIngredients: [String] = []
    @Published var userCategories: [String] = []
    @Published var userSides: [String] = []
    
    init(){
//        getUserItems()
    }
    
    // MARK: - Get Ingredients

    

}
