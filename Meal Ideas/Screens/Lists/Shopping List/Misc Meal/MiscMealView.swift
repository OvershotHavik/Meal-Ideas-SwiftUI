//
//  MiscMealView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 3/3/22.
//

import SwiftUI

struct MiscMealView: View{
    @StateObject var vm = MiscMealVM(meal: nil)
    @EnvironmentObject var shopping : Shopping

    var body: some View{
        Form{
            Section(header: Text(SectionHeaders.ingredients.rawValue)){
                IngredientSelectView(vm: vm)
                    .foregroundColor(.blue)
                MiscMealIngredientHStack(vm: vm)
            }
        }
        .onAppear(perform: {
            vm.convertToUserIngredient(allShoppingList: shopping.allShoppingList)
            vm.convertToShoppingList(allShoppingList: shopping.allShoppingList) // needed if user doesn't add a measurement, this will add the ingredient to the records
            shopping.getShoppingList()
        })
        .onDisappear(perform: {
            vm.convertToShoppingList(allShoppingList: shopping.allShoppingList)
            shopping.getShoppingList()
        })
        .navigationTitle(Text(Titles.misc.rawValue))
    }
}



struct MiscMealIngredientHStack: View{
    @StateObject var vm: MiscMealVM

    
    var body: some View{
        ForEach($vm.userIngredients) {$ing in
            HStack{
                Text(ing.name)
                Spacer()
                TextField("Measurement", text: $ing.measurement)
                    .textFieldStyle(CustomRoundedCornerTextField())
                    .frame(width: 150)
            }
        }
        .onDelete(perform: vm.deleteIngredient)
    }
}
