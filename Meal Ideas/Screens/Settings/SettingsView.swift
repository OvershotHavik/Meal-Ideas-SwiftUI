//
//  SettingsView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsVM()
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Edit Your Items")){
                    NavigationLink(destination: EditItemList(vm: EditItemListVM(title: .editCategories, listItems: vm.userCategories))) {
                        Text(Titles.editCategories.rawValue)
                    }
                    
                    NavigationLink(destination: EditItemList(vm: EditItemListVM(title: .editIngredients, listItems: vm.userIngredients))) {
                        Text(Titles.editIngredients.rawValue)
                    }
                    
                    NavigationLink(destination: EditItemList(vm: EditItemListVM(title: .editSides, listItems: vm.userSides))) {
                        Text(Titles.editSides.rawValue)
                    }
                }
            }
            .navigationTitle(Titles.settings.rawValue)
            
        }


    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
