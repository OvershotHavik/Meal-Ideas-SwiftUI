//
//  MyIdeasDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MyIdeasDetailView: View {
    @StateObject var vm : MyIdeasDetailVM
    @EnvironmentObject var query: Query
    @EnvironmentObject var shopping: Shopping
    
    var body: some View {
        ZStack{
            vm.backgroundColor
                .ignoresSafeArea()
            VStack(spacing: 10){
                ScrollView{
                    Spacer(minLength: 5)
                    
                    if let safeData = vm.meal?.mealPhoto{
                        CDPhotoView(photoData: safeData, website: vm.meal?.source)
                            .modifier(MealPhotoModifier())
                    } else {
                        Image(uiImage: UIImage(imageLiteralResourceName: ImageNames.placeholderMeal.rawValue))
                            .resizable()
                            .modifier(MealPhotoModifier())
                    }
                    MealNameView(name: vm.meal?.mealName ?? "No Name Provided")
                    UserPrepHStack(hour: vm.meal?.prepHour,
                                   minute: vm.meal?.prepMinute,
                                   second: vm.meal?.prepSecond)
                    if let safeCategories = vm.meal?.category as? [String]{
                        if safeCategories.count != 0{
                            BadgesHStack(title: "Categories",
                                         items: safeCategories,
                                         topColor: .blue,
                                         bottomColor: .blue)
                        }
                    }
                    if let safeSides = vm.meal?.sides as? [String]{
                        if safeSides.count != 0{
                            BadgesHStack(title: "Sides",
                                         items: safeSides,
                                         topColor: .green,
                                         bottomColor: .green)
                        }
                    }
                    if vm.meal?.ingredients as? [String] != []{
                        DetailViewIngredientListView(ingredients: vm.meal?.ingredients as? [String] ?? [],
                                                     measurements: vm.meal?.measurements as? [String] ?? [],
                                                     mealName: vm.meal?.mealName ?? "")
                    }

                    if vm.meal?.instructionsPhoto != nil{
                        CDPhotoView(photoData: vm.meal?.instructionsPhoto)
                            .frame(width: 200, height: 200)
                    }
                    RecipeView(recipe: vm.meal?.recipe ?? "No recipe Provided")
                }
                LinkView(url: vm.meal?.source, title: "Visit Source")
            }
            .padding()
            .onAppear{
                shopping.getShoppingList()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("Share tapped")
                        vm.shareTapped()
                    } label: {
                        Image(systemName: SFSymbols.share.rawValue)
                            .foregroundColor(.blue)
                    }

                    Button {
                        vm.favorited.toggle()
                        vm.favoriteToggled()
                        query.getFavorites()
                    } label: {
                        if vm.meal != nil{
                            Image(systemName: vm.favorited ? SFSymbols.favorited.rawValue : SFSymbols.unFavorited.rawValue)
                                .foregroundColor(.pink)
                        }
                    }
                }
            }
        }
    }
}
