//
//  MealPhotoView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealPhotoView: View {
    var mealPhoto: String // will need changed once working
    var body: some View {
        Image(mealPhoto)
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
    }
}

struct MealPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        MealPhotoView(mealPhoto: "Pizza")
    }
}
