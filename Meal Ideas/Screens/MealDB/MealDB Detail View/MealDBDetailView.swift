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
                
                BadgesHStack(title: "Category",
                             items: [vm.meal.strCategory ?? ""],
                             topColor: .blue,
                             bottomColor: .black)
                
                IngredientVGrid(ingredients: vm.meal.ingredientsArray,
                                measurements: vm.meal.measurementsArray)
                
                RecipeView(recipe: vm.meal.strInstructions ?? "")
                
                LinkView(url: vm.meal.strYoutube ?? "", title: "Visit Youtube Link")
            }

            LinkView(url: vm.meal.strSource ?? "", title: "Visit Source")
                .navigationTitle(vm.meal.strMeal ?? "")

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