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
    @EnvironmentObject var shopping: Shopping
    
    
    var body: some View {
        ZStack{
            vm.backgroundColor
                .ignoresSafeArea()
            if vm.isLoading{
                loadingView()
            }
            VStack{
                ScrollView{
                    Spacer(minLength: 5)

                    MealPhotoUIImageView(mealPhoto: vm.mealPhoto, website: vm.meal?.sourceUrl)
                    
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

                    if !vm.ingredients.isEmpty{
                        Text(Messages.addToShoppingList.rawValue)
                    }
                    DetailViewIngredientListView(ingredients: vm.ingredients,
                                                 measurements: vm.measurements,
                                                 mealName: vm.meal?.title ?? "")
                    
                    RecipeView(recipe: vm.instructions)
                }
                LinkView(url: vm.meal?.sourceUrl, title: "Visit Source")
            }
            
            .padding()
            .onAppear{
                shopping.getShoppingList()
            }
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if let website = vm.meal?.sourceUrl{
                        if website != ""{
                            Button {
                                print("Share tapped")
                                vm.presentShareAS(website: website)
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    Button {
                        vm.favorited.toggle()
                        vm.favoriteToggled()
                        query.getFavorites()
                    } label: {
                        if vm.meal != nil{
                            Image(systemName: vm.favorited ? "heart.fill" : "heart")
                                .foregroundColor(.pink)
                        }
                    }
                }
            }
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
