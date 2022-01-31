//
//  BaseVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/6/22.
//

import SwiftUI

class BaseVM: ObservableObject{
    @Published var backgroundColor = Color(UIColor.secondarySystemBackground)
    @Published var alertItem : AlertItem?
    @Published var isLoading = false
    @Published var originalQueryType = QueryType.none
    @Published var originalQuery = ""
    @Published var keywordSearchTapped = false
    @Published var getMoreMeals = false
    @Published var getRandomMeals = false
    @Published var moreToShow = false
    @Published var offsetBy: Int = 0 // changes by 10
    @Published var allResultsShown = false
    @Published var totalMealCount = 0
    @Published var showWelcome = true
    @Published var surpriseMealReady = false
    @Published var sourceCategories: [String] = []
    @Published var sourceCategory: PList
    //For scroll views
    @Published var scrollViewContentOffset = CGFloat(0)
    @Published var largestY = CGFloat(0)
    @Published var showTopView = true

    //Custom filter
    @Published var customKeyword: String?
    @Published var customCategory: String?
    @Published var customIngredient: String?
    @Published var originalCustomKeyword: String?
    @Published var originalCustomCategory: String?
    @Published var originalCustomIngredient: String?
    
    
    init(sourceCategory: PList){
        self.sourceCategory = sourceCategory
        fetchPlist(plist: sourceCategory)
    }
    
    // MARK: - Reset Values
    func resetValues(){
        alertItem = nil
        isLoading = false
        originalQueryType = QueryType.none
        originalQuery = ""
        keywordSearchTapped = false
        getMoreMeals = false
        getRandomMeals = false
        moreToShow = false
        offsetBy = 0 // changes by 10
        allResultsShown = false
        totalMealCount = 0
    }
    
    // MARK: - Auto Hide Top View
    func autoHideTopView(){
        withAnimation(.easeOut){
            if scrollViewContentOffset < UI.topViewOffsetSpacing{
                showTopView = true
            } else {
                showTopView = false
            }
            
            if scrollViewContentOffset > largestY{
                //user is scrolling down
                largestY = scrollViewContentOffset
                
            } else {
                //user started scrolling up again, show the view and set largest Y to current value
                showTopView = true
                largestY = scrollViewContentOffset
            }
        }

//        print("offset value: \(scrollViewContentOffset)")
    }
    
    // MARK: - Fetch Plsit for category verification
    func fetchPlist(plist: PList){
        if sourceCategories.isEmpty{
            PListManager.loadItemsFromLocalPlist(XcodePlist: plist,
                                                 classToDecodeTo: [NewItem].self,
                                                 completionHandler: { [weak self] result in
                if let self = self {
                    switch result {
                    case .success(let itemArray):
                        self.sourceCategories = itemArray.map{$0.itemName}
                    case .failure(let e): print(e)
                    }
                }
            })
        }
    }

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
