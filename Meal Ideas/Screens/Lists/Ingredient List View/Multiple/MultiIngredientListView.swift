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
        //May want to switch to a forEach loop instead if list doesn't work the way I want to do the selections.. Could have the cell update if it has a check mark or not if it is in the title matches the selected
        
//        List{a
//            ForEach(vm.ingredients) {ingredient in
//                IngredientCell(ingredient: ingredient)
//                    .onTapGesture {
//
//                        isActive.toggle()
//                        print(ingredient.strIngredient)
//                    }
//                    .listRowBackground(ingredient.strIngredient == selection ? Color.green : Color.clear)
//            }
//        }
        
        
        List(vm.ingredients){ ingredient in
            IngredientCell(ingredient: ingredient)
                .onTapGesture {
                    vm.checkArray(item: ingredient.strIngredient)
                }
                .listRowBackground(vm.selectedArray.contains(ingredient.strIngredient) ? Color.green : Color.clear)
//                .listRowBackground(ingredient.strIngredient == vm. ? Color.green : Color.clear)
        }
        
        .navigationTitle(Text("Select an Ingredient"))
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
