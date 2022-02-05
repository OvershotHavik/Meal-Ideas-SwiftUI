//
//  MealPhotoView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealPhotoUIImageView: View{
    var mealPhoto: UIImage
    
    var body: some View{
        HStack {
            NavigationLink(destination: ZoomImageView(image: mealPhoto)) {
                Image(uiImage: mealPhoto)
                    .resizable()
                    .modifier(MealPhotoModifier())
            }
        }
    }
}
// MARK: - Core Data Meal Photo View
struct CDPhotoView: View{
    var photoData: Data?
    var image = UIImage()
    @StateObject var imageLoader = ImageLoaderFromData()

    var body: some View{
        ZStack{
            if photoData != nil{

                NavigationLink(destination: ZoomImageView(image: imageLoader.image)) {

                    Image(uiImage: (imageLoader.image))
                        .resizable()
                    
                }
                if imageLoader.isLoading{
                    loadingView()
                }
            } else {
                Image(uiImage: UIImage(imageLiteralResourceName: ImageNames.placeholderMeal.rawValue))
                    .resizable()
            }
        }
        .task{
            if let safeData = photoData{
                imageLoader.loadFromData(mealPhotoData: safeData)
            } else {
                imageLoader.isLoading = false
            }
        }
    }

}
/*
struct MealPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        MealPhotoView(mealPhoto: "Pizza")
    }
}
*/
