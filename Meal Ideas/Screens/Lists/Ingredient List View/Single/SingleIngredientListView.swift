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
//        UITableView.appearance().backgroundColor =  .secondarySystemBackground

        ZStack{
            List(vm.searchResults, selection: $vm.selection){ ingredient in

                let selected = ingredient.strIngredient == vm.selection
                IngredientCell(ingredient: ingredient, selected: selected)
                    .onTapGesture {
                        query.selected = ingredient.strIngredient
                        query.customIngredient = ingredient.strIngredient
                        dismiss()
                    }
            }
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

            .onAppear {
//                UITableView.appearance().backgroundColor =  .secondarySystemBackground
//                UITableViewCell.appearance().backgroundColor = Color.lightBlue
            }
            if vm.itemList.contains(UI.noIngredient){
                NoResultsView(message: UI.noIngredient)
            }
            
            if vm.isLoading{
                loadingView()
                    .offset(y: UI.verticalSpacing)
            }
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}
/*
struct IngredientsListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleIngredientListView(vm: SingleIngredientsListVM())
    }
}
*/
