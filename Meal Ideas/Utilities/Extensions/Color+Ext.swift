//
//  Color+Ext.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

extension UIColor{
    static let darkBlue = #colorLiteral(red: 0, green: 0.2479205846, blue: 0.5144915803, alpha: 1)
    static let lightBlue = #colorLiteral(red: 0.2405282193, green: 0.5033387822, blue: 1, alpha: 1)

}


extension Color{
    static let ui = Color.UI()
    struct UI {
         let textFieldBackground = Color("TextFieldBackground")
    }
}
/*
 keeping for future use, if I can figure out how to get the status bar text color to change correctly based on what view is shown, I would use this to modify the text color of the top view based on the colors the user picks
extension Color{
    func isLight() -> Bool {
        guard let components = cgColor?.components, components.count > 2 else {return false}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
}
*/
