//
//  MealDBDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MealDBDetailView: View {
    @StateObject var vm : MealDBDetailVM
//    var meal: MealDBResults.Meal
    
    var body: some View {
        VStack{
            ScrollView{
                MealPhotoView(mealPhoto: vm.meal.strMealThumb ?? "")
                
                MealNameView(name: vm.meal.strMeal ?? "")
                
                BadgesHStack(categories: [vm.meal.strCategory ?? ""] )
                
                IngredientVGrid(ingredients: vm.meal.ingredientsArray,
                                measurements: vm.meal.measurementsArray)
                
                RecipeView(recipe: vm.meal.strInstructions ?? "")
                
                YoutubeLinkView(youtubeLink: vm.meal.strYoutube ?? "")
            }

            SourceLinkView(source: vm.meal.strSource ?? "")
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
