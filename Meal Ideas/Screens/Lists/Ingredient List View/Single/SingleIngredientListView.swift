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
        ZStack{
            List(vm.searchResults.sorted{$0.strIngredient < $1.strIngredient}, selection: $vm.selection){ ingredient in
                
                let selected = ingredient.strIngredient == vm.selection
                IngredientCell(ingredient: ingredient, selected: selected)
                    .onTapGesture {
                        query.selected = ingredient.strIngredient
                        query.customIngredient = ingredient.strIngredient
                        dismiss()
                    }
            }
            .padding(.bottom)
            .toolbar{
                ToolbarItem(placement: .principal) {
                    Text(Titles.oneIngredient.rawValue)
                }
            }
            .searchable(text: $vm.searchText)
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
            if vm.itemList.contains(Messages.noIngredient.rawValue){
                NoResultsView(message: Messages.noIngredient.rawValue)
            }
            
            if vm.isLoading{
                loadingView()
                    .offset(y: UI.verticalSpacing)
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}
