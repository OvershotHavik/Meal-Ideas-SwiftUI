//
//  BaseVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/6/22.
//

import Foundation

class BaseVM{
    @Published var alertItem : AlertItem?
    @Published var isLoading = false
    @Published var originalQueryType = QueryType.none
    @Published var originalQuery: String?
    @Published var keywordSearchTapped = false
    @Published var getMoreMeals = false
    @Published var getRandomMeals = false
}
