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

    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
                .opacity(0.25)

            VStack{
                HistoryFavoriteHStack(inHistory: inHistory,
                                      favorited: favorited)
                if mealPhotoData != nil{
                    if let safeData = mealPhotoData{
                        Image(uiImage: (UIImage(data: safeData) ?? UIImage(imageLiteralResourceName: UI.placeholderMeal)))
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
                    }
                } else {
                    LoadRemoteImageView(urlString: mealPhoto)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                }

                Text(mealName)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding([.bottom, .horizontal], 5)
            }
        }
        .onAppear{
//            loadImage()
        }
        .frame(width: 160, height: 210)
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
            Text("")
            Spacer()
            if favorited == true {
                Image(systemName:"heart.fill") // If favorited is true, then show book, if not, show nothing
                    .foregroundColor(.pink)
                    .padding([.trailing, .top])
            }

        }
    }
}
