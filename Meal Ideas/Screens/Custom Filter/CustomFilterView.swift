//
//  CustomFilterView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/24/22.
//

import SwiftUI

struct CustomFilterView: View {
    @StateObject var vm : CustomFilterVM
    @EnvironmentObject var query: Query
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        Form{
            Section{
                TextField("Search...", text: $query.customKeyword)
                
                CustomCategoryNL(vm: vm)
                
                if query.customCategory != ""{
                    BadgesHStack(title: "Category:", items: [query.customCategory], topColor: .blue, bottomColor: .blue)
                }
                
                CustomIngredientNL(vm: vm)
                
                if query.customIngredient != ""{
                    BadgesHStack(title: "Ingredient:", items: [query.customIngredient], topColor: .green, bottomColor: .green)
                }
            }
            
            Section{
                Button {
                    print("Go back to the view to perform search")
                    dismiss()
                    
                } label: {
                    Text("Search")
                        .foregroundColor(.blue)
                }
                if query.customKeyword != "" ||
                    query.customCategory != "" ||
                    query.customIngredient != ""{
                    Button {
                        print("Reset")
                        query.customKeyword = ""
                        query.customCategory = ""
                        query.customIngredient = ""
                    } label: {
                        Text("Reset")
                            .foregroundColor(.red)
                    }
                }
                
            }
            
        }
        .toolbar{
            ToolbarItem(placement: .principal, content: {
                Text(Titles.customFilter.rawValue)
            })
        }
    }
}
/*
struct CustomFilterView_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomFilterView(vm: CustomFilterVM(source: .myIdeas, plist: nil, listItems: []))
    }
}
*/

struct CustomCategoryNL: View{
    @StateObject var vm: CustomFilterVM
    @EnvironmentObject var query: Query

    var body: some View{
        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: vm.plist,
                                                                                listItems: vm.source == .myIdeas ? vm.userCategories : [],
                                                                                singleChoiceString: query.customCategory,
                                                                                title: .oneCategory))) {
            Text("Select a Category")
        }
                                                         .foregroundColor(.blue)
    }

}


struct CustomIngredientNL: View{
    @StateObject var vm: CustomFilterVM
    var body: some View{
        
        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: vm.userIngredients))) {
            Text("Select an ingredient")
        }                                                         .foregroundColor(.blue)

    }
}
