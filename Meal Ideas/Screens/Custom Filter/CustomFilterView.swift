//
//  CustomFilterView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/24/22.
//

import SwiftUI

struct CustomFilterView: View {
    
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var query: Query
    @Binding var keyword: String
    @Binding var category: String
    @Binding var ingredient: String
    @Binding var showAllUserMealIdeas: Bool
    var source: Source
    var plist: PList?
    var userIngredients: [String]
    var userCategories: [String]
    
    
    
//    @StateObject var vm : CustomFilterVM
    var body: some View {
        
        Form{
            Section{
                TextField("Search...", text: $keyword)
                // TODO:  Figure out why query is getting lost when the keyboard dismisses
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
/*
struct CustomFilterView_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomFilterView(vm: CustomFilterVM(source: .myIdeas, plist: nil, listItems: []))
    }
}
*/

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
//    @StateObject var vm: CustomFilterVM
    var userIngredients: [String]
    @Binding var ingredient: String
    var body: some View{
        
        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: userIngredients, selection: ingredient))) {
            Text("Select an ingredient")
        }                                                         .foregroundColor(.blue)
    }
}



/*
 original using environment that was failing when the user is on a physical ipad and the keyboard dismisses, somehow it loses the environment object and caused it to crash.. so switched to binding values in the VM
 
 struct CustomFilterView: View {
     
     @Environment(\.dismiss) var dismiss
     @EnvironmentObject var query: Query
     @StateObject var vm : CustomFilterVM
     var body: some View {
         
         Form{
             Section{
                 TextField("Search...", text: $query.customKeyword)
                 // TODO:  Figure out why query is getting lost when the keyboard dismisses
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
             if vm.source == .myIdeas{
                 Section(header: Text(SectionHeaders.none.rawValue)){
                     Button {
                         print("Show All tapped")
                         query.showAllUserMealIdeas = true
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
 //    @StateObject var vm: CustomFilterVM
 //    @EnvironmentObject var query: Query

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
 //    @StateObject var vm: CustomFilterVM
     var body: some View{
         
         NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: vm.userIngredients, selection: nil))) {
             Text("Select an ingredient")
         }                                                         .foregroundColor(.blue)
     }
 }

 
 */
