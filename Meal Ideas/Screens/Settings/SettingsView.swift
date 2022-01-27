//
//  SettingsView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsVM()
//    @AppStorage("TestColor") var testColor = ""
    @State var topLeft = ""
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Change Gradient Colors")){
                    BackgroundGradientView()
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(20)
                    
                    // MARK: - Top Left
                    ColorPicker("Top Left", selection: Binding(get: {
                        vm.topLeftColor
                    }, set: { newValue in
                        vm.userSettings.topLeftColor = vm.updateColor(color: newValue)
                        vm.topLeftColor = newValue
                        vm.saveChanges()
                    }))
                        .onAppear{
                            vm.convertStringToColorTopLeft()
                        }
                    // MARK: - Bottom Right
                    ColorPicker("Bottom Right", selection: Binding(get: {
                        vm.bottomRightColor
                    }, set: { newValue in
                        vm.userSettings.bottomRightColor = vm.updateColor(color: newValue)
                        vm.bottomRightColor = newValue
                        vm.saveChanges()
                    }))
                        .onAppear{
                            vm.convertStringToColorBottomRight()
                        }
                }

                
                Section(header: Text("Edit Your Items")){
                    NavigationLink(destination: EditItemList(vm: EditItemListVM(title: .editCategories,
                                                                                listType: .category,
                                                                                entityName: .CDCategory))) {
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
                                                                                entityName: .CDSides))) {
                        Text(Titles.editSides.rawValue)
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK")))
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
