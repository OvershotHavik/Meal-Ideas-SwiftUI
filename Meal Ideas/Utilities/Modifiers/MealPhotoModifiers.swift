//
//  MealCardPhotoMod.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/20/22.
//

import Foundation
import SwiftUI

struct MealCardPhotoModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
        //resizable needs to be applied to the image itself
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white,lineWidth:4).shadow(radius: 10))
    }
}

struct MealPhotoModifier: ViewModifier{
    func body(content: Content) -> some View{
        content
        //resizable needs to be applied to the image itself
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white,lineWidth:4).shadow(radius: 10))
    }
}
