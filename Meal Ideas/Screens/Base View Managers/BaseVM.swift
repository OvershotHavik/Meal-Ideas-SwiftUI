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
    @Published var source: Source
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
    
    
    init(sourceCategory: PList, source: Source){
        self.sourceCategory = sourceCategory
        self.source = source
        fetchPlist(plist: sourceCategory)
    }


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
    }

    
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
    
    
    @MainActor func checkQuery(query: String, queryType: QueryType){
        //override in sub class
    }
    
    
    @MainActor func customFilter(keyword: String, category: String, ingredient: String){
        //override in sub class
    }
    
    
    @MainActor func clearMeals(){
        //override  in sub class
    }
    
    
    @MainActor func sourceOnAppear(queryType: QueryType, selected: String, customKeyword: String, customCategory: String, customIngredient: String){
        
        if queryType == .category ||
            queryType == .ingredient{
            if selected == ""{
                //nothing selected, if we let it go it brings back random results
                return
            }
        }
        if queryType == .custom{
            if source != .myIdeas{
                if !sourceCategories.contains(customCategory) &&
                    customCategory != ""{
                    //If the user selected a category that isn't supported, return with no meals
                    resetValues()
                    clearMeals()
                    showWelcome = false
                    return
                } else {
                    customFilter(keyword: customKeyword,
                                    category: customCategory,
                                    ingredient: customIngredient)
                }
            } else {
                //My ideas doesn't need to check for category
                customFilter(keyword: customKeyword,
                                category: customCategory,
                                ingredient: customIngredient)
            }


            return
        }
        if queryType == originalQueryType && selected == originalQuery{
            //nothing changed, don't do anything
            return
        }
        
        if queryType == .none ||
            queryType == .random{
            return
        } else {
            if source != .myIdeas{
                //only needs checked on other sources
                if queryType == .category{
                    //Only do this check if the query type is categories
                    if !sourceCategories.contains(selected) &&
                        selected != ""{
                        //If the user selected a category that isn't supported, return with no meals
                        resetValues()
                        clearMeals()
                        showWelcome = false
                        return
                    }
                }
            }

            showWelcome = false
            checkQuery(query: selected, queryType: queryType)
        }
    }
}
