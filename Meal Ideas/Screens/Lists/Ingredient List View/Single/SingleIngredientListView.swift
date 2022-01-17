//
//  IngredientsListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//


import SwiftUI

struct SingleIngredientListView: View {
    @StateObject var vm: IngredientListVM
    @EnvironmentObject var query: Query
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack{
            if vm.isLoading{
                loadingView()
                    .offset(y: UI.verticalSpacing)
            }
            List(vm.searchResults, selection: $vm.selection){ ingredient in

                let selected = ingredient.strIngredient == vm.selection
                IngredientCell(ingredient: ingredient, selected: selected)
                    .onTapGesture {
                        query.selected = ingredient.strIngredient
                        dismiss()
                    }
            }
            .searchable(text: $vm.searchText)
            .navigationTitle(Titles.oneIngredient.rawValue)
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }

            .onAppear{
                query.queryType = .ingredient
            }
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
