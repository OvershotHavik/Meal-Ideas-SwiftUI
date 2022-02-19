//
//  ShoppingListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/19/22.
//

import SwiftUI

struct ShoppingListView: View {
    @StateObject var vm = ShoppingListVM()
    var body: some View {
        VStack{
            
            HStack{
                if vm.anyChecked{
                    Button {
                        print("delete checked")
                    } label: {
                        Text("Delete checked items")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                
                Spacer()
                Button  {
                    print("Clear all")
                    PersistenceController.shared.clearAllShoppingList()
                    vm.getShoppingList()
                } label: {
                    Text("Clear all items")
                }
                .buttonStyle(.borderedProminent)
                
                
            }
            .accentColor(.red)
            .padding()
            
            Form {
                ForEach(vm.mealNames, id: \.self){ meal in
                    Section(header: Text(meal)){
                        let filteredMeals = vm.allShoppingList.filter({$0.mealName == meal})
                        ForEach(filteredMeals, id: \.self) { i in
                            DetailViewIngredientCell(ingredient: i.ingredient ?? "",
                                                     measurement: i.measurement ?? "",
                                                     selected: i.checkedOff,
                                                     mealName: "")                            //Add to the tap gesture to change the record to show the check in Core data
                            
                        }
                    }
                }
            }
        }
        .onAppear{
            vm.getShoppingList()
            //get the meal names from core data
            
        }
        
    }
    
}



struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
