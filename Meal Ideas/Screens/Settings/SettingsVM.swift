//
//  SettingsVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import SwiftUI
import CoreData

@MainActor final class SettingsVM: ObservableObject{
    @Published var test = ""
    @Published var userIngredients: [String] = []
    @Published var userCategories: [String] = []
    @Published var userSides: [String] = []
//    @Published var topLeftColor: UIColor = .red

    @Published var alertItem : AlertItem?
//    // TODO:  Rename the app storage to not include the number
//    @AppStorage("userSettings1") private var userSettingsData: Data?

    init(){
//        getUserItems()
//        retrieveUserSettings()
    }


    // MARK: - Update Color
    func updateColor(color: Color) -> String{
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red,
                       green: &green,
                       blue: &blue,
                       alpha: &alpha)
        

        return "\(red),\(green),\(blue),\(alpha)"
    }
    

}
