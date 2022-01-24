//
//  CustomFilterView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/24/22.
//

import SwiftUI

struct CustomFilterView: View {
    @StateObject var vm : CustomFilterVM
    var body: some View {
        Form{
            TextField("Search...", text: $vm.name)
            
            NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: vm.plist,
                                                                                    listItems: vm.listItems),
                                                             title: .oneCategory)) {
                Text("Select a Category")
            }
                                                             .foregroundColor(.blue)
            
            if vm.category != ""{
                BadgesHStack(title: "Category:", items: [vm.category], topColor: .blue, bottomColor: .blue)
            }
            
            
            NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: vm.plist,
                                                                                    listItems: vm.listItems),
                                                             title: .oneIngredient)) {
                Text("Select an Ingredient")
            }
                                                             .foregroundColor(.blue)
            if vm.ingredient != ""{
                BadgesHStack(title: "Ingredient:", items: [vm.ingredient], topColor: .green, bottomColor: .green)
            }

            Button {
                print("Do the search")
            } label: {
                Text("Search")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
            }

        }
        .toolbar{
            ToolbarItem(placement: .principal, content: {
                Text(Titles.customFilter.rawValue)
            })
        }
    }
}

struct CustomFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CustomFilterView(vm: CustomFilterVM(source: .myIdeas, plist: nil, listItems: []))
    }
}
