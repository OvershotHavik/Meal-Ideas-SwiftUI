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
                CDPhotoView(photoData: vm.meal.mealPhoto)
                
                MealNameView(name: vm.meal.mealName ?? "No Name Provided")
                
                BadgesHStack(title: "Categories",
                             items: vm.meal.category as! [String],
                             topColor: .blue,
                             bottomColor: .black)
                
                IngredientVGrid(ingredients: vm.meal.ingredients as! [String],
                                measurements: vm.meal.measurements as! [String?])
                
                CDPhotoView(photoData: vm.meal.instructionsPhoto)
                
                RecipeView(recipe: vm.meal.recipe ?? "No recipe Provided")
            }
            LinkView(url: vm.meal.source, title: "Visit Source")
                .navigationTitle(vm.meal.mealName ?? "")
        }
    }
}

/*
struct MyIdeasDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasDetailView(vm: MyIdeasDetailVM(meal: MockData.userMealSample))
    }
}
*/
