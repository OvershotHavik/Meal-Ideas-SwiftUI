//
//  SpoonDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct SpoonDetailView: View {
    @StateObject var vm: SpoonDetailVM
    
    var body: some View {
        VStack{
            ScrollView{
                if vm.isLoading{
                    loadingView()
                }
//                MealPhotoView(mealPhoto: vm.meal?.image ?? "")
                MealPhotoUIImageView(mealPhoto: vm.mealPhoto)
                
                MealNameView(name: vm.meal?.title.withoutHtmlTags ?? "")
                
                SpoonServingPrepHStack(prepTime: vm.meal?.readyInMinutes,
                                       servings: vm.meal?.servings)
                
                //For each HStack, check to see if there is at least 1 in each array, if not don't display it.
                if vm.meal?.dishTypes?.count ?? 0 > 0{
                    BadgesHStack(title: "Category",
                                 items: vm.meal?.dishTypes ?? [],
                                 topColor: .blue,
                                 bottomColor: .black)
                }
                
                if vm.meal?.diets?.count ?? 0 > 0{
                    BadgesHStack(title: "Diet",
                                 items: vm.meal?.diets ?? [],
                                 topColor: .yellow,
                                 bottomColor: .black)
                }

                if vm.meal?.occasions?.count ?? 0 > 0{
                    BadgesHStack(title: "Occasion",
                                 items: vm.meal?.occasions ?? [],
                                 topColor: .pink,
                                 bottomColor: .black)
                }

                IngredientVGrid(ingredients: vm.ingredients,
                                measurements: vm.measurements)

                
                RecipeView(recipe: vm.instructions)
            }
            LinkView(url: vm.meal?.sourceUrl, title: "Visit Source")
                .navigationTitle(vm.meal?.title ?? "")

        }
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title,
                         message: alertItem.message,
                  dismissButton: .default(Text("OK")))
        }
        
    }
}

/*
struct SpoonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpoonDetailView(vm: SpoonDetailVM)
    }
}
*/
