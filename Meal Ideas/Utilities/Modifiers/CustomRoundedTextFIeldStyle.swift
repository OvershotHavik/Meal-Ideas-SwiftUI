//
//  CustomRoundedTextFIeldStyle.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/6/22.
//

import SwiftUI

struct CustomRoundedCornerTextField: TextFieldStyle {
    //usage:
    //.textFieldStyle(CustomRoundedCornerTextField())

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color(UI.textFieldBackground))
            .cornerRadius(10)
    }
}
