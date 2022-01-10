//
//  BaseVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/6/22.
//

import SwiftUI

class BaseVM: ObservableObject{
    @Published var alertItem : AlertItem?
    @Published var isLoading = false
    @Published var originalQueryType = QueryType.none
    @Published var originalQuery: String?
    @Published var keywordSearchTapped = false
    @Published var getMoreMeals = false
    @Published var getRandomMeals = false
    @Published var lessThanTen = false
    @Published var offsetBy: Int = 0 // changes by 10  each time get more meals is tapped
}


class DetailBaseVM: ObservableObject{
    @Published var isLoading = false
    @Published var alertItem : AlertItem?
    @Published var ingredients: [String] = []
    @Published var measurements: [String] = []
    @Published var instructions: String = ""
    @Published var mealPhoto = UIImage()
    @Published var favorited = false
    @Published var showingHistory =  false
    @Published var backgroundColor = Color(UIColor.secondarySystemBackground)
}
