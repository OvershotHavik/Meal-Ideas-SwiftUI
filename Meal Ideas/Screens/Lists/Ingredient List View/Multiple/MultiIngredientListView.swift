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
            List(vm.searchResults.sorted{$0.strIngredient < $1.strIngredient}){ ingredient in
                
                let selected = vm.selectedArray.contains(ingredient.strIngredient)
                IngredientCell(ingredient: ingredient, selected: selected)
                    .onTapGesture {
                        vm.checkArray(item: ingredient.strIngredient)
                    }
            }
            .alert(isPresented: $vm.showTextAlert,
                   TextAlert(title: "Add a new \(vm.listType)", message: "This will be added to this meal. \nThis will also be available for future meals", action: { result in
                if let text = result{
                    if vm.listType == .ingredient{
                        print("Add ingredient: \(text)")
                        vm.addItem(item: text)
                        PersistenceController.shared.addUserItem(entityName: .CDIngredient, item: text)
                    }
                }
            }))
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text(Titles.multiIngredients.rawValue)
                }
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
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
        }
    }
}
