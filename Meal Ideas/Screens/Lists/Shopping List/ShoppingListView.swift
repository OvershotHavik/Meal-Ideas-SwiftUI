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
                NavigationLink(destination: MiscMealView(), label: {
                    Text("Add Misc Items")
                        .bold()
                        .modifier(MIButtonModifier())
                })
                
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

            .onAppear{
                shopping.getShoppingList()
                vm.allShoppingList = shopping.allShoppingList
                vm.mealNames = shopping.mealNames
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
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
                    
                    if !shopping.allShoppingList.isEmpty{
                        Button {
                            print("Share tapped")
                            vm.shareTapped(allShoppingList: shopping.allShoppingList)
                        } label: {
                            Image(systemName: SFSymbols.share.rawValue)
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .principal, content: {
                    Text(Titles.shoppingList.rawValue)
                })
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !shopping.allShoppingList.isEmpty{
                        Button  {
                            withAnimation {
                                vm.showingClearAllAlert.toggle()
                            }
                        } label: {
                            Image(systemName: SFSymbols.trash.rawValue)
                        }
                        .accentColor(.red)
                    }
                }
            }
        }
        .accentColor(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowShoppingListOnboarding, content: {
            ShoppingListOnboardingView(shouldShowShoppingListOnboarding: $shouldShowShoppingListOnboarding)
        })
    }
}
