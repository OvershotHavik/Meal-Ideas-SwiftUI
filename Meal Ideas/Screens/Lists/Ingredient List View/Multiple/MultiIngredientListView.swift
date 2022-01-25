//
//  MultiIngredientListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI

struct MultiIngredientListView: View {
    @StateObject var vm: MultiIngredientListVM
    @EnvironmentObject var query: Query
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack{
            if vm.isLoading{
                loadingView()
                    .offset(y: UI.verticalSpacing)
            }
            List(vm.searchResults){ ingredient in

                let selected = vm.selectedArray.contains(ingredient.strIngredient)
                IngredientCell(ingredient: ingredient, selected: selected)
                    .onTapGesture {
                        vm.checkArray(item: ingredient.strIngredient)
                    }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        print("Bring up the new item alert with text field")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert(isPresented: $vm.showTextAlert,
                   TextAlert(title: "Add a new \(vm.listType)", message: "This will be added to this meal. \nThis will also be available for future meals", action: { result in
                if let text = result{
                    if vm.listType == .ingredients{
                        print("Add ingredient: \(text)")
                    }

                }
            }))
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        print("Bring up the new item alert with text field")
                        vm.showTextAlert.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .searchable(text: $vm.searchText)
            .navigationTitle(Titles.multiIngredients.rawValue)
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
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
