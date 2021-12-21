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
    
    var body: some View {

            VStack{
                ScrollView{
                    CDPhotoView(photoData: vm.meal?.mealPhoto)
                        .frame(width: 200, height: 200)
                    
                    MealNameView(name: vm.meal?.mealName ?? "No Name Provided")
                    
                    BadgesHStack(title: "Categories",
                                 items: vm.meal?.category as! [String],
                                 topColor: .blue,
                                 bottomColor: .black)
                    
                    IngredientVGrid(ingredients: vm.meal?.ingredients as! [String],
                                    measurements: vm.meal?.measurements as! [String?])
                    
                    CDPhotoView(photoData: vm.meal?.instructionsPhoto)
                        .frame(width: 200, height: 200)
                    RecipeView(recipe: vm.meal?.recipe ?? "No recipe Provided")
                }
                
                LinkView(url: vm.meal?.source, title: "Visit Source")
                    .navigationTitle(vm.meal?.mealName ?? "")
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
            .onAppear(perform: vm.addToHistory)
        
    }
}

/*
struct MyIdeasDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasDetailView(vm: MyIdeasDetailVM(meal: MockData.userMealSample))
    }
}
*/
