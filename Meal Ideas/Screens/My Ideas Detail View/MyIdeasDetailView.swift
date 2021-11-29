//
//  MyIdeasDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MyIdeasDetailView: View {
    
    @ObservedObject var vm : MyIdeasDetailVM
    
    var body: some View {
        VStack{
            ScrollView{
                MealPhotoView(mealPhoto: vm.meal.mealPhoto)
                
                MealNameView(name: vm.meal.mealName)
                
                
                BadgesHStack(title: "Categories",
                             items: vm.meal.category,
                             topColor: .blue,
                             bottomColor: .black)
                
                
                IngredientVGrid(ingredients: vm.meal.ingredients, measurements: vm.meal.measurements ?? [])
                
                RecipeView(recipe: vm.meal.recipe)
            }
            LinkView(url: vm.meal.source, title: "Visit Source")
            .navigationTitle(vm.meal.mealName)
        }
    }
}

struct MyIdeasDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasDetailView(vm: MyIdeasDetailVM(meal: MockData.userMealSample))
    }
}
