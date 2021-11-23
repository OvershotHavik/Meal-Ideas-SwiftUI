//
//  MyIdeasDetailVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

final class MyIdeasDetailVM: ObservableObject{
    
    @Published var  meal: SampleUserMealModel
    
    init(meal: SampleUserMealModel){
        self.meal = meal
    }
    
}
