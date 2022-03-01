//
//  MealDBDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealDBDetailView: View {
    @StateObject var vm : MealDBDetailVM
    @EnvironmentObject var query: Query
    @EnvironmentObject var shopping: Shopping
    var body: some View {
        ZStack{
            vm.backgroundColor
                .ignoresSafeArea()
            if vm.isLoading{
                loadingView()
            }
            VStack{
                ScrollView{
                    Spacer(minLength: 5)

                    MealPhotoUIImageView(mealPhoto: vm.mealPhoto, website: vm.meal?.strSource)
                    
                    MealNameView(name: vm.meal?.strMeal ?? "")
                    
                    BadgesHStack(title: "Category",
                                 items: [vm.meal?.strCategory ?? ""],
                                 topColor: .blue,
                                 bottomColor: .blue)
                    
                    DetailViewIngredientListView(ingredients: vm.meal?.ingredientsArray ?? [],
                                                 measurements: vm.meal?.measurementsArray ?? [],
                                                 mealName: vm.meal?.strMeal ?? "")
                    
                    RecipeView(recipe: vm.meal?.strInstructions ?? "")
                    
                    LinkView(url: vm.meal?.strYoutube ?? "", title: "Visit Youtube Link")
                }
                
                LinkView(url: vm.meal?.strSource ?? "", title: "Visit Source")
            }
            .padding()
            .onAppear{
                shopping.getShoppingList()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if let website = vm.meal?.strSource{
                        if website != ""{
                            Button {
                                print("Share tapped")
                                vm.presentShareAS(website: website)
                            } label: {
                                Image(systemName: SFSymbols.share.rawValue)
                                    .foregroundColor(.blue)
                            }
                        }
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
