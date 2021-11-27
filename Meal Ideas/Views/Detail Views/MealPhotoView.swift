//
//  MealPhotoView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealPhotoView: View {
    var mealPhoto: String // will need to figure out how to get this to work once core data is used for my meals, getting it to work for meal db and spoon for now.. may just need to create a different view and just use that on the my meals view..
    var body: some View {
        LoadRemoteImageView(urlString: mealPhoto)
            .frame(width: 200, height: 200)
            .clipShape(Circle())
    }
}

struct MealPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        MealPhotoView(mealPhoto: "Pizza")
    }
}
