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

                    MealPhotoUIImageView(mealPhoto: vm.mealPhoto)
                    
                    MealNameView(name: vm.meal?.strMeal ?? "")
                    
                    BadgesHStack(title: "Category",
                                 items: [vm.meal?.strCategory ?? ""],
                                 topColor: .blue,
                                 bottomColor: .blue)
                    DetailViewIngredientListView(ingredients: vm.meal?.ingredientsArray ?? [],
                                                 measurements: vm.meal?.measurementsArray ?? [])
                    
                    RecipeView(recipe: vm.meal?.strInstructions ?? "")
                    
                    LinkView(url: vm.meal?.strYoutube ?? "", title: "Visit Youtube Link")
                }
                
                LinkView(url: vm.meal?.strSource ?? "", title: "Visit Source")
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.favorited.toggle()
                        vm.favoriteToggled()
                        query.getFavorites()
                    } label: {
                        Image(systemName: vm.favorited ? "heart.fill" : "heart")
                            .foregroundColor(.pink)
                    }
                }
            }
        }        
    }
}
