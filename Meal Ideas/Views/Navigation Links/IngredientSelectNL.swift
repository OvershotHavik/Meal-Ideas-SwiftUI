//
//  IngredientSelectNL.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 5/1/22.
//

import SwiftUI

struct IngredientSelectNL: View{
    @StateObject var vm: EditIdeaVM
    
    var body: some View{
        NavigationLink(destination: MultiIngredientListView(vm: MultiIngredientListVM(editVM: vm,
                                                                                      listType: .ingredient))) {
            Text("Select Ingredients")
        }
    }
}
