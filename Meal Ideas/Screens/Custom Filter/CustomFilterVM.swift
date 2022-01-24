//
//  CustomFilterVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/24/22.
//

import Foundation

@MainActor final class CustomFilterVM: ObservableObject{
    @Published var source: Source
    @Published var plist: PList?
    @Published var userIngredients: [String]
    @Published var userCategories: [String]
    
    init(source: Source, plist: PList?, userIngredients: [String], userCategories: [String]){
        self.source = source
        self.plist = plist
        self.userIngredients = userIngredients
        self.userCategories = userCategories
    }
}
