//
//  MultiIngredientListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI

struct MultiIngredientListView: View {
    @StateObject var vm: IngredientListVM
    @EnvironmentObject var query: Query
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        List(vm.ingredients){ ingredient in
            let selected = vm.selectedArray.contains(ingredient.strIngredient)
            IngredientCell(ingredient: ingredient, selected: selected)
                .onTapGesture {
                    vm.checkArray(item: ingredient.strIngredient)
                }
        }
        
        .navigationTitle(Titles.multiIngredients.rawValue)
        .toolbar{ EditButton() }

        
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}
/*
struct IngredientsListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleIngredientListView(vm: SingleIngredientsListVM())
    }
}
*/
