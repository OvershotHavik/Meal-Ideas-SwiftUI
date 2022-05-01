//
//  MealPhotoView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealPhotoUIImageView: View{
    var mealPhoto: UIImage
    var website: String?
    
    var body: some View{
        HStack {
            NavigationLink(destination: ZoomImageView(image: mealPhoto, website: website)) {
                Image(uiImage: mealPhoto)
                    .resizable()
                    .modifier(MealPhotoModifier())
            }
        }
    }
}


struct CDPhotoView: View{
    var photoData: Data?
    var image = UIImage()
    var website: String?
    @StateObject var imageLoader = ImageLoaderFromData()
    
    var body: some View{
        ZStack{
            if photoData != nil{
                NavigationLink(destination: ZoomImageView(image: imageLoader.image, website: website)) {
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
