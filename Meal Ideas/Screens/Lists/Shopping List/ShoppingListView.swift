//
//  ShoppingListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/19/22.
//

import SwiftUI

struct ShoppingListView: View {
    @StateObject var vm = ShoppingListVM()
    @EnvironmentObject var shopping : Shopping
    @AppStorage("shouldShowShoppingListOnboarding") var shouldShowShoppingListOnboarding: Bool = true
    
    
    var body: some View {
        NavigationView{
            VStack{
                if shopping.allShoppingList.isEmpty{
                    NoResultsView(message: Messages.noShoppingList.rawValue)
                }
                Form {
                    ForEach(vm.mealNames, id: \.self){ meal in
                        Section(header: Text(meal)){
                            let filteredMeals = vm.searchResults.filter({$0.mealName == meal})
                            ForEach(filteredMeals, id: \.self) { i in
                                DetailViewIngredientCell(ingredient: i.ingredient ?? "",
                                                         measurement: i.measurement ?? "",
                                                         selected: i.checkedOff,
                                                         mealName: i.mealName ?? "",
                                                         inShoppingList: true)
                            }
                        }
                    }
                }
                
                .searchable(text: $vm.searchText)
                // Clear Checked Alert
                .alert("Are you sure you want to clear checked items?", isPresented: $vm.showingClearCheckedAlert) {
                    Button("Clear Checked Items", role: .destructive) {
                        withAnimation {
                            PersistenceController.shared.removeCheckedItems()
                            shopping.getShoppingList()
                            vm.allShoppingList = shopping.allShoppingList
                            vm.mealNames = shopping.mealNames
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
                // Clear All Alert
                .alert("Are you sure you want to clear all items?", isPresented: $vm.showingClearAllAlert) {
                    Button("Clear All Items", role: .destructive) {
                        withAnimation {
                            PersistenceController.shared.clearAllShoppingList()
                            shopping.getShoppingList()
                            vm.allShoppingList = shopping.allShoppingList
                            vm.mealNames = shopping.mealNames
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if shopping.anyChecked{
                        Button {
                            withAnimation {
                                vm.showingClearCheckedAlert.toggle()
                            }
                        } label: {
                            Text("Remove Checked")
                        }
                        .accentColor(.red)
                    }
                }
                ToolbarItem(placement: .principal, content: {
                    Text(Titles.shoppingList.rawValue)
                })
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !shopping.allShoppingList.isEmpty{
                        Button  {
                            withAnimation {
                                vm.showingClearAllAlert.toggle()
                            }
                        } label: {
                            Text("Clear All")
                        }
                        .accentColor(.red)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowShoppingListOnboarding, content: {
            ShoppingListOnboardingView(shouldShowShoppingListOnboarding: $shouldShowShoppingListOnboarding)
        })
        .onAppear{
            shopping.getShoppingList()
            vm.allShoppingList = shopping.allShoppingList
            vm.mealNames = shopping.mealNames
        }
    }
}
