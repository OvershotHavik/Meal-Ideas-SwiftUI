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
                    NavigationLink(destination: EditItemList(vm: EditItemListVM(title: .editCategories,
                                                                                listType: .category,
                                                                                entityName: .CDUserCategory))) {
                        Text(Titles.editCategories.rawValue)
                            .foregroundColor(.blue)
                    }
                    
                    NavigationLink(destination: EditItemList(vm: EditItemListVM(title: .editIngredients,
                                                                                listType: .ingredient,
                                                                                entityName: .CDIngredient))) {
                        Text(Titles.editIngredients.rawValue)
                            .foregroundColor(.blue)
                    }
                    
                    NavigationLink(destination: EditItemList(vm: EditItemListVM(title: .editSides,
                                                                                listType: .side,
                                                                                entityName: .CDUserSides))) {
                        Text(Titles.editSides.rawValue)
                            .foregroundColor(.blue)
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
