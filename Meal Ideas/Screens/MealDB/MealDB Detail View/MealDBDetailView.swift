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

            VStack{
                ScrollView{
                    if vm.isLoading{
                        loadingView()
                    }
//                    MealPhotoView(mealPhoto: vm.meal?.strMealThumb ?? "")
                    MealPhotoUIImageView(mealPhoto: vm.mealPhoto)
                    
                    MealNameView(name: vm.meal?.strMeal ?? "")
                    
                    BadgesHStack(title: "Category",
                                 items: [vm.meal?.strCategory ?? ""],
                                 topColor: .blue,
                                 bottomColor: .black)
                    
                    IngredientVGrid(ingredients: vm.meal?.ingredientsArray ?? [],
                                    measurements: vm.meal?.measurementsArray ?? [])
                    
                    RecipeView(recipe: vm.meal?.strInstructions ?? "")
                    
                    LinkView(url: vm.meal?.strYoutube ?? "", title: "Visit Youtube Link")
                }

                LinkView(url: vm.meal?.strSource ?? "", title: "Visit Source")
                    .navigationTitle(vm.meal?.strMeal ?? "")
            }
            .padding(.horizontal)
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

/*
struct MealDBDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDBDetailView(meal: MealDBResults.Meal())
    }
}
*/
