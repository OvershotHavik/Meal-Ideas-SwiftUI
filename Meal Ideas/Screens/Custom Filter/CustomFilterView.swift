//
//  CustomFilterView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/24/22.
//

import SwiftUI

struct CustomFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var keyword: String
    @Binding var category: String
    @Binding var ingredient: String
    @Binding var showAllUserMealIdeas: Bool
    var source: Source
    var plist: PList?
    var userIngredients: [String]
    var userCategories: [String]
    
    
    var body: some View {
        
        Form{
            Section{
                TextField("Search...", text: $keyword)
                CustomCategoryNL(plist: plist,
                                 userCategories: userCategories,
                                 source: source,
                                 category: $category)
                
                if category != ""{
                    BadgesHStack(title: "Category:", items: [category], topColor: .blue, bottomColor: .blue)
                }
                
                CustomIngredientNL(userIngredients: userIngredients,
                                   ingredient: $ingredient)
                
                if ingredient != ""{
                    BadgesHStack(title: "Ingredient:", items: [ingredient], topColor: .green, bottomColor: .green)
                }
            }
            
            Section{
                Button {
                    print("Go back to the view to perform search")
                    showAllUserMealIdeas = false
                    dismiss()
                    
                } label: {
                    Text("Search")
                        .foregroundColor(.blue)
                }
                if keyword != "" ||
                    category != "" ||
                    ingredient != ""{
                    Button {
                        print("Reset")
                        keyword = ""
                        category = ""
                        ingredient = ""
                    } label: {
                        Text("Reset")
                            .foregroundColor(.red)
                    }
                }
            }
            if source == .myIdeas{
                Section(header: Text(SectionHeaders.none.rawValue)){
                    Button {
                        print("Show All tapped")
                        showAllUserMealIdeas = true
                        dismiss()

                    } label: {
                        Text("Show all your ideas")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .toolbar{
            ToolbarItem(placement: .principal, content: {
                Text(Titles.customFilter.rawValue)
            })
        }
    }
}


struct CustomCategoryNL: View{
    var plist: PList?
    var userCategories: [String]
    var source: Source
    @Binding var category: String

    
    var body: some View{
        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: plist,
                                                                                listItems: source == .myIdeas ? userCategories : [],
                                                                                singleChoiceString: category,
                                                                                title: .oneCategory))) {
            Text("Select a Category")
        }
                                                         .foregroundColor(.blue)
    }
}


struct CustomIngredientNL: View{
    var userIngredients: [String]
    @Binding var ingredient: String
    
    
    var body: some View{
        
        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: userIngredients, selection: ingredient))) {
            Text("Select an ingredient")
        }                                                         .foregroundColor(.blue)
    }
}
