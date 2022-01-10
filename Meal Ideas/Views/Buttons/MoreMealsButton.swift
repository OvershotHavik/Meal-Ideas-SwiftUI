//
//  MoreMealsButton.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/10/22.
//

import SwiftUI

struct MoreMealsButton: View{
    @StateObject var vm: BaseVM
    var body: some View{
        Button {
            vm.getMoreMeals.toggle()
        } label: {
            Text("Get more meals")
        }
        .buttonStyle(.bordered)
        .padding(25)
    }
}


