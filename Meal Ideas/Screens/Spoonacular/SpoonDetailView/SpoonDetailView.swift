//
//  SpoonDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct SpoonDetailView: View {
    @StateObject var vm: SpoonDetailVM
    @EnvironmentObject var query: Query
    
    var body: some View {
        ZStack{
//            vm.backgroundColor
//                .ignoresSafeArea()
            BackgroundGradientView()
            VStack{
                ScrollView{
                    Spacer(minLength: 5)

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
                                     bottomColor: .blue)
                    }
                    
                    if vm.meal?.diets?.count ?? 0 > 0{
                        BadgesHStack(title: "Diet",
                                     items: vm.meal?.diets ?? [],
                                     topColor: .green,
                                     bottomColor: .green)
                    }
                    
                    if vm.meal?.occasions?.count ?? 0 > 0{
                        BadgesHStack(title: "Occasion",
                                     items: vm.meal?.occasions ?? [],
                                     topColor: .pink,
                                     bottomColor: .pink)
                    }
                    
                    //                IngredientVGrid(ingredients: vm.ingredients,
                    //                                measurements: vm.measurements)
                    DetailViewIngredientListView(ingredients: vm.ingredients,
                                                 measurements: vm.measurements)
                    
                    
                    RecipeView(recipe: vm.instructions)
                }
                LinkView(url: vm.meal?.sourceUrl, title: "Visit Source")
               
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .principal, content: {
                    Text(vm.meal?.title ?? "")
                })
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
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK")))
            }
//            .onAppear(perform: vm.addToHistory)
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
