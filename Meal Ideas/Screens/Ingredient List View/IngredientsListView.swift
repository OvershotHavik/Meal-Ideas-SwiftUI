//
//  IngredientsListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//


import SwiftUI

struct IngredientsListView: View {
    @StateObject var vm: IngredientsListVM
    @EnvironmentObject var query: Query
    @Binding var isActive: Bool
    @State var selection: String?
    var body: some View {
        //May want to switch to a forEach loop instead if list doesn't work the way I want to do the selections.. Could have the cell update if it has a check mark or not if it is in the title matches the selected
        
//        List{
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
        
        
        List(vm.ingredients, selection: $selection){ ingredient in
            IngredientCell(ingredient: ingredient)
                .onTapGesture {
                    query.selected = ingredient.strIngredient
                    isActive.toggle()
                }
         .listRowBackground(ingredient.strIngredient == selection ? Color.green : Color.clear)
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

struct IngredientsListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsListView(vm: IngredientsListVM(), isActive: .constant(true))
    }
}
