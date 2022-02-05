//
//  UserSettings.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/27/22.
//

import SwiftUI

final class UserEnvironment: ObservableObject{
    // TODO:  Rename the app storage to not include the number
    @AppStorage("userSettings1") private var userSettingsData: Data?
    @Published var topLeftColor: Color = Color(uiColor: .lightBlue)
    @Published var bottomRightColor: Color = Color(uiColor: .darkBlue)
    @Published var userSettings = UserSettings()
    @Published var alertItem: AlertItem?
    
    init(){
        retrieveUserSettings()
        convertStringToColorTopLeft()
        convertStringToColorBottomRight()
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
    // MARK: - Convert String to Color top left
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
    
    // MARK: - Convert String to Color bottom RIght 
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
