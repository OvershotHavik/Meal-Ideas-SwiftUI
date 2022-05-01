//
//  MenuCustomNL.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/6/22.
//

import SwiftUI

struct MenuCustomNL: View{
    @EnvironmentObject var query: Query
    var source: Source
    var userIngredients: [String]
    var userCategories: [String]
    var plist: PList?
    
    var body: some View{
        NavigationLink(destination: CustomFilterView(keyword: $query.customKeyword,
                                                     category: $query.customCategory,
                                                     ingredient: $query.customIngredient,
                                                     showAllUserMealIdeas: $query.showAllUserMealIdeas,
                                                     source: source,
                                                     plist: plist,
                                                     userIngredients: userIngredients,
                                                     userCategories: userCategories),
                       tag: QueryType.custom,
                       selection: $query.menuSelection)
        {
            EmptyView()
        }
    }
}
