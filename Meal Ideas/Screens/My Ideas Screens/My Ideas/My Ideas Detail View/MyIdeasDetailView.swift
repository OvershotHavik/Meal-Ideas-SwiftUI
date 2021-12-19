//
//  MyIdeasDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MyIdeasDetailView: View {
    
    @ObservedObject var vm : MyIdeasDetailVM
    @EnvironmentObject var query: Query
    
    var body: some View {
        if let safeMeal = vm.meal{
            VStack{
                ScrollView{
                    CDPhotoView(photoData: safeMeal.mealPhoto)
                    
                    MealNameView(name: safeMeal.mealName ?? "No Name Provided")
                    
                    BadgesHStack(title: "Categories",
                                 items: safeMeal.category as! [String],
                                 topColor: .blue,
                                 bottomColor: .black)
                    
                    IngredientVGrid(ingredients: safeMeal.ingredients as! [String],
                                    measurements: safeMeal.measurements as! [String?])
                    
                    CDPhotoView(photoData: safeMeal.instructionsPhoto)
                    
                    RecipeView(recipe: safeMeal.recipe ?? "No recipe Provided")
                }
                
                LinkView(url: safeMeal.source, title: "Visit Source")
                    .navigationTitle(safeMeal.mealName ?? "")
            }
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

/*
struct MyIdeasDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasDetailView(vm: MyIdeasDetailVM(meal: MockData.userMealSample))
    }
}
*/
