//
//  File.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext{
    
    // MARK: - Network Alerts
    static let invalidData       = AlertItem(title: Text("No Meals"),
                                             message: Text("No meals where found for your search."),
                                             dismissButton: .default(Text("OK")))
    
    static let invalidResponse   = AlertItem(title: Text("Server Error"),
                                             message: Text("Invalid response from the server. Please try again later or contact support."),
                                             dismissButton: .default(Text("OK")))
    
    static let invalidURL         = AlertItem(title: Text("Server Error"),
                                              message: Text("There was an issue connecting to the server. If this persists, please contact support."),
                                              dismissButton: .default(Text("OK")))
    
    static let unableToComplete   = AlertItem(title: Text("Server Error"),
                                              message: Text("Unable to complete your request at this time. Please check your internet connection."),
                                              dismissButton: .default(Text("OK")))
    
    // MARK: - Core Data
    static let unableToSave   = AlertItem(title: Text("Save Error"),
                                              message: Text("Unable to save to device. Please try closing the app and starting again"),
                                              dismissButton: .default(Text("OK")))
}
