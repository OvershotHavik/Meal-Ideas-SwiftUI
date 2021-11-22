//
//  MealCardView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct MealCardView: View {
//    @State var userMeal: UserMealModel?
    @State var userMeal: SampleUserMealModel?
    var spoonMeal: SpoonacularResults?
    var mealdbMeal: MealDBResults?
    
    //Will need to figure out how to get these to work later
    @State var inHistory = true
    @State var inFavorites = true
    
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)

            VStack{
                HistoryFavoriteHStack(inHistory: $inHistory,
                                      inFavorites: $inFavorites)
                Image(userMeal?.mealPhoto ?? "")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                Text(userMeal?.mealName ?? "")
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
        MealCardView(userMeal: MockData.userMealSample)
    }
}

struct HistoryFavoriteHStack: View{
    @Binding var inHistory: Bool
    @Binding var inFavorites: Bool
    var body: some View{
        HStack{
            Image(systemName: "book")
                .padding([.leading, .top])
            Spacer()
            Image(systemName: "heart.fill")
                .foregroundColor(.pink)
                .padding([.trailing, .top])
        }
    }
}
