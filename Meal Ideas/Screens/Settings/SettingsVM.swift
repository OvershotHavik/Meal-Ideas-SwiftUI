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
    @Published var topLeftColor = Color.red
    @Published var bottomRightColor = Color.purple
    @Published var userSettings = UserSettings()
    @Published var alertItem : AlertItem?
    // TODO:  Rename the app storage to not include the number
    @AppStorage("userSettings1") private var userSettingsData: Data?

    init(){
//        getUserItems()
        retrieveUserSettings()
    }
    
    // MARK: - Save user settings
    func saveChanges(){
        do {
            let data = try JSONEncoder().encode(userSettings)
            userSettingsData = data
            print("Saved to app storage")
        } catch {
            alertItem = AlertContext.invalidUserData
        }
    }
    // MARK: - Retrieve user settings
    func retrieveUserSettings(){
        guard let userSettingsData = userSettingsData else {return}
        
        do {
            userSettings = try JSONDecoder().decode(UserSettings.self, from: userSettingsData)
            print("retrieved settings")
        } catch let e {
            print("error: \(e.localizedDescription)")
            alertItem = AlertContext.invalidUserData
        }
    }

    // MARK: - Update COlor
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
    
    func convertStringToColorTopLeft(){
        if userSettings.topLeftColor != "" {
            let rgbArray = userSettings.topLeftColor.components(separatedBy: ",")
            if let red = Double(rgbArray[0]),
               let green = Double(rgbArray[1]),
               let blue = Double(rgbArray[2]),
               let alpha = Double(rgbArray[3]){
                topLeftColor = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            }
        }
    }
    
    
    func convertStringToColorBottomRight(){
        if userSettings.bottomRightColor != "" {
            let rgbArray = userSettings.bottomRightColor.components(separatedBy: ",")
            if let red = Double(rgbArray[0]),
               let green = Double(rgbArray[1]),
               let blue = Double(rgbArray[2]),
               let alpha = Double(rgbArray[3]){
                bottomRightColor = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            }
        }
    }
}
