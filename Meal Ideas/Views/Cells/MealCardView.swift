//
//  MealCardView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct MealCardView: View {
    var mealPhoto: String
    var mealPhotoData: Data?
    
    var mealName: String
    var favorited: Bool
    var inHistory: Bool
    @StateObject var imageLoader = ImageLoaderFromData()

    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
//                .opacity(0.25)

            VStack{
                HistoryFavoriteHStack(inHistory: inHistory,
                                      favorited: favorited)
                if mealPhotoData != nil{
                    ZStack{
                        if let safeData = mealPhotoData{
                            Image(uiImage: (UIImage(data: safeData) ?? UIImage(imageLiteralResourceName: UI.placeholderMeal)))
                                .resizable()

                        }
//                        Image(uiImage: imageLoader.image)
//                            .resizable()


                        if imageLoader.isLoading{
                            loadingView()
                        }
                    }
                    .modifier(MealCardPhotoModifier())
                        
//                        Image(uiImage: (UIImage(data: safeData) ?? UIImage(imageLiteralResourceName: UI.placeholderMeal)))

                    
                } else {
                    LoadRemoteImageView(urlString: mealPhoto)
                        .modifier(MealCardPhotoModifier())

                }

                Text("\(mealName)\n") // adds an extra line to the meal name. If it is only 1 line, then it adds a blank line below. If it is already 2 lines, then the third "blank" line gets cut off. This will keep all meal cards aligned correctly
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding([.bottom, .horizontal], 5)
            }
        }
        .onAppear{
            if let safeData = mealPhotoData{
                imageLoader.loadFromData(mealPhotoData: safeData)
            }
            

        }
        .frame(width: 160, height: 210)
//        .frame(idealWidth: 160, idealHeight: 210)
        .cornerRadius(10)
//        .shadow(color: .black, radius: 5, x: 0, y: 0)
    }
    /*
    func loadImage(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let safeData = self?.mealPhotoData{
                let tempImage = UIImage(data: safeData)
                DispatchQueue.main.async { [weak self] in
                    self?.image = tempImage
                }
            }
        }
    }
     */
}

struct MealCardView_Previews: PreviewProvider {
    static var previews: some View {
        MealCardView(mealPhoto: "Pizza",
                     mealName: "test name",
                     favorited: true,
                     inHistory: true)
    }
}
// MARK: - History Favorites H Stack
struct HistoryFavoriteHStack: View{
    
    //need to change accordingly
    var inHistory: Bool
    var favorited: Bool
    var body: some View{
        HStack{
            if inHistory == true {
                Image(systemName: "book") // If in history is true, then show book, if not, show nothing
                    .padding([.leading, .top])
                    .opacity(0.50)
            }
            Spacer()
            if favorited == true {
                Image(systemName:"heart.fill") // If favorited is true, then show book, if not, show nothing
                    .foregroundColor(.pink)
                    .padding([.trailing, .top])
            }
        }
        .frame(height: 30)
    }
}
