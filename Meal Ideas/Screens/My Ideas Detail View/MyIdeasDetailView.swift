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
                
                BadgesHStack(categories: vm.meal.category)
                
                IngredientVGrid(ingredients: vm.meal.ingredients, measurements: vm.meal.measurements)
                
                RecipeView(recipe: vm.meal.recipe)
            }
            SourceLinkView(source: vm.meal.source)
            .padding()
        }
    }
}

struct MyIdeasDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasDetailView(vm: MyIdeasDetailVM(meal: MockData.userMealSample))
    }
}
