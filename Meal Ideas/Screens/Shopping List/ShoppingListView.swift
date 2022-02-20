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
    var body: some View {
        NavigationView{
            VStack{
                if shopping.allShoppingList.isEmpty{
                    NoResultsView(message: Messages.noShoppingList.rawValue)
                }
                HStack{
                    if shopping.anyChecked{
                        Button {
                            print("delete checked")
                            withAnimation {
                                PersistenceController.shared.removeCheckedItems()
                                shopping.getShoppingList()
                            }

                        } label: {
                            Text("Delete checked items")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Spacer()
                    
                    if !shopping.allShoppingList.isEmpty{
                        Button  {
                            print("Clear all")
                            withAnimation {
                                PersistenceController.shared.clearAllShoppingList()
                                shopping.getShoppingList()
                            }

                        } label: {
                            Text("Clear all items")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .accentColor(.red)
                .padding()
                
                Form {
                    ForEach(shopping.mealNames, id: \.self){ meal in
                        Section(header: Text(meal)){
                            let filteredMeals = shopping.allShoppingList.filter({$0.mealName == meal})
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
                .navigationTitle(Text(Titles.shoppingList.rawValue))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear{
            shopping.getShoppingList()
        }
    }
}



struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
