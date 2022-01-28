//
//  UserSettings.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/27/22.
//

import SwiftUI


struct UserSettings: Codable{
    var topLeftColor : String = ""
    var bottomRightColor : String = ""
}


final class UserEnvironment: ObservableObject{
    // TODO:  Rename the app storage to not include the number
    @AppStorage("userSettings1") private var userSettingsData: Data?
    @Published var topLeftColor: Color = Color(uiColor: .lightBlue)
    @Published var bottomRightColor: Color = Color(uiColor: .darkBlue)
//    @Published var bottomRightColor = Color(.sRGB, red: 0, green: 0.2479205846, blue: 0.5144915803, opacity: 1)
//    @Published var bottomRightColor = Color(uiColor: .darkBlue)
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
