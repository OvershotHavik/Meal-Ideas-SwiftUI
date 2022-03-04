//
//  SettingsView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm = SettingsVM()
    @EnvironmentObject var userEnvironment: UserEnvironment
    
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Change Gradient Colors")){
                    SampleTopView()
                    
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                    //Top Left
                    ColorPicker("Top Left", selection: Binding(get: {
                        userEnvironment.topLeftColor
                    }, set: { newValue in
                        userEnvironment.userSettings.topLeftColor = vm.updateColor(color: newValue)
                        userEnvironment.topLeftColor = newValue
                        userEnvironment.saveChanges()
                    }))
                        .onAppear{
                            userEnvironment.convertStringToColorTopLeft()
                        }
                    //  Bottom Right
                    ColorPicker("Bottom Right", selection: Binding(get: {
                        userEnvironment.bottomRightColor
                    }, set: { newValue in
                        userEnvironment.userSettings.bottomRightColor = vm.updateColor(color: newValue)
                        userEnvironment.bottomRightColor = newValue
                        userEnvironment.saveChanges()
                    }))
                        .onAppear{
                            userEnvironment.convertStringToColorBottomRight()
                        }
                    if userEnvironment.topLeftColor !=  Color(uiColor: .lightBlue) ||
                        userEnvironment.bottomRightColor != Color(uiColor: .darkBlue){
                        Button {
                            print("Reset values")
                            userEnvironment.topLeftColor = Color(uiColor: .lightBlue)
                            userEnvironment.userSettings.topLeftColor = vm.updateColor(color: Color(uiColor: .lightBlue))
                            
                            
                            userEnvironment.bottomRightColor = Color(uiColor: .darkBlue)
                            userEnvironment.userSettings.bottomRightColor = vm.updateColor(color: Color(uiColor: .darkBlue))
                            
                            
                            userEnvironment.saveChanges()
                        } label: {
                            Text("Reset Colors")
                                .foregroundColor(.blue)
                        }
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
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK")))
            }
            .toolbar{
                ToolbarItem(placement: .principal, content: {
                    Text(Titles.settings.rawValue)
                })
            }
        }
        .accentColor(.primary)
        .foregroundColor(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct SampleTopView: View{
    @EnvironmentObject var userEnvironment: UserEnvironment
    @State var sample = ""
    
    
    var body: some View{
        HStack(spacing: 5){
            Text("Surprise \nMe")
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            TextField("Sample", text: $sample)
                .textFieldStyle(CustomRoundedCornerTextField())
            
            Image(systemName: SFSymbols.filter.rawValue)
                .foregroundColor(.primary)
        }
        .padding()
        
        .background(BackgroundGradientView())
    }
}
