//
//  MealPhotoView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealPhotoView: View {
    var mealPhoto: String 
    var body: some View {
        LoadRemoteImageView(urlString: mealPhoto)
            .frame(width: 200, height: 200)
            .clipShape(Circle())
    }
}
// MARK: - Core Data Meal Photo View
struct CDPhotoView: View{
    var photoData: Data?
    var body: some View{
        if let safeData = photoData{
            Image(uiImage: (UIImage(data: safeData) ?? UIImage(imageLiteralResourceName: "Placeholder")))
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
        } else {
            Image("Placeholder")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
        }
    }

}

struct MealPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        MealPhotoView(mealPhoto: "Pizza")
    }
}
