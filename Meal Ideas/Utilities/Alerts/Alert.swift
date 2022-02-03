//
//  File.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext{
    static let noSelection       = AlertItem(title: Text("No Selection"),
                                             message: Text("Please choose something to search by."),
                                             dismissButton: .default(Text("OK")))
    
    static let noMeals       = AlertItem(title: Text("No Meals"),
                                             message: Text("No meals have been created. \nTap the Edit icon to create one."),
                                             dismissButton: .default(Text("OK")))
    // MARK: - Network Alerts
    static let invalidData       = AlertItem(title: Text("No Meals"),
                                             message: Text("No meals where found for your search."),
                                             dismissButton: .default(Text("OK")))
    
    static let invalidResponse   = AlertItem(title: Text("Server Error"),
                                             message: Text("Invalid response from the server. \nPlease try again later or contact support."),
                                             dismissButton: .default(Text("OK")))
    
    // MARK: - App Storage error
    static let invalidUserData = AlertItem(title: Text("Profile Error"),
                                           message: Text("There was an error saving or retrieving your settings"),
                                           dismissButton: .default(Text("OK")))
    
    // TODO:  Fix errors to make more sense for end user
    static let invalidURL         = AlertItem(title: Text("Server Error"),
                                              message: Text("Invalid URL."),
                                              dismissButton: .default(Text("OK")))
    
    static let unableToComplete   = AlertItem(title: Text("Server Error"),
                                              message: Text("Unable to complete your request at this time. \nPlease check your internet connection."),
                                              dismissButton: .default(Text("OK")))
    
    // MARK: - Core Data
    static let unableToSave      = AlertItem(title: Text("Save Error"),
                                              message: Text("Unable to save to device. \nPlease try closing the app and starting again"),
                                              dismissButton: .default(Text("OK")))
    
    static let nameInUse         = AlertItem(title: Text("Meal name already in use"),
                                              message: Text("The name provided is already in use.\nPlease choose a different name."),
                                              dismissButton: .default(Text("OK")))
    
    static let blankMealName      = AlertItem(title: Text("Meal name missing"),
                                              message: Text("Please enter a name for your meal."),
                                              dismissButton: .default(Text("OK")))
    
    static let invalidSourceURL      = AlertItem(title: Text("Invalid Source"),
                                              message: Text("The source provided is not a valid URL. \nPlease correct."),
                                              dismissButton: .default(Text("OK")))
}
