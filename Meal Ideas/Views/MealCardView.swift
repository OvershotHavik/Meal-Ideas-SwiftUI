//
//  MealCardView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct MealCardView: View {
    var mealPhoto: String // will need changed for data once that is setup
    var mealName: String
    var favorited: Bool
    var inHistory: Bool
    
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)

            VStack{
                HistoryFavoriteHStack(inHistory: inHistory,
                                      favorited: favorited)
                Image(mealPhoto)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                Text(mealName)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding([.bottom, .horizontal], 5)
//                    .scaledToFit()
//                    .minimumScaleFactor(0.6)
            }
        }
        .frame(width: 160, height: 210)
        .cornerRadius(10)
        .shadow(color: .black, radius: 5, x: 0, y: 0)
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

struct HistoryFavoriteHStack: View{
    
    //need to change accordingly
    var inHistory: Bool
    var favorited: Bool
    var body: some View{
        HStack{
            Image(systemName: inHistory ? "book" : "") // If in history is true, then show book, if not, show nothing
                .padding([.leading, .top])
            Spacer()
            Image(systemName: favorited ? "heart.fill" : "") // If favorited is true, then show book, if not, show nothing
                .foregroundColor(.pink)
                .padding([.trailing, .top])
        }
    }
}
