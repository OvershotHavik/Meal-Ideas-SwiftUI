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
    let placeholder = UIImage(imageLiteralResourceName: ImageNames.placeholderMeal.rawValue)
    @State var mealImage = UIImage()
    
    
    var body: some View {
        ZStack{
            Color(UIColor.tertiarySystemBackground)

            VStack{
                HistoryFavoriteHStack(inHistory: inHistory,
                                      favorited: favorited)
                if mealPhotoData != nil{
                    ZStack{
                        if mealImage != UIImage(){
                            Image(uiImage: mealImage)
                                .resizable()
                        } else {
                            Image(uiImage: placeholder)
                                .resizable()
                        }
                    }
                    .modifier(MealCardPhotoModifier())
                   
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
                CacheManager.shared.returnImageFromData(photoData: safeData) { imageFromData in
                    if let safeImage = imageFromData{
                        mealImage = safeImage
                    }
                }
            }
        }
        .cornerRadius(10)
    }
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
    var inHistory: Bool
    var favorited: Bool
    var body: some View{
        HStack{
            if favorited == true {
                Image(systemName:"heart.fill") // If favorited is true, then show book, if not, show nothing
                    .foregroundColor(.pink)
                    .padding([.trailing, .top])
            }
            
            Spacer()
            
            if inHistory == true {
                Image(systemName: "book") // If in history is true, then show book, if not, show nothing
                    .padding([.leading, .top])
                    .opacity(0.50)
            }
        }
        .padding()
        .frame(height: 30)
    }
}






/*
struct aSpoonServingPrepHStack: View {
    var prepTime: Int?
    var servings: Int?
    @State private var convertedTime: String?
    var body: some View {
        HStack{
            //if either are nil, hide the icon as well
            if prepTime != nil{
                Image(systemName: "timer")
                Text(convertedTime ?? "")
            }

            if let safeServings = servings{
                Image(systemName: "person.fill")
                Text("\(safeServings)")
            }
        }
        .onAppear{
            if let safePrepTime = prepTime{
                let result = minutesToHoursAndMinutes(safePrepTime)
                
                if result.hours != 0{
                    convertedTime = "\(result.hours) h \(result.leftMinutes) m"
                } else {
                    convertedTime = "\(result.leftMinutes) min"
                }
            }
        }
    }
        
    func minutesToHoursAndMinutes (minutes : Int) -> String{
        
        let hours = minutes / 60
        let leftoverMinutes = minutes % 60
        
        if hours != 0{
            return   "\(hours) h \(leftoverMinutes) m"
        } else {
            return  "\(leftoverMinutes) min"
        }
//        return (minutes / 60, (minutes % 60))
    }
    
    
}

*/
