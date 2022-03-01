//
//  MenuIngredientNL.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/6/22.
//

import SwiftUI

struct MenuIngredientsNL: View{
    @EnvironmentObject var query: Query
    var userIngredients: [String]
    
    
    var body: some View{
        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: userIngredients,
                                                                                  selection: query.selected)),
                       tag: QueryType.ingredient,
                       selection: $query.menuSelection) { EmptyView()}
    }
}
