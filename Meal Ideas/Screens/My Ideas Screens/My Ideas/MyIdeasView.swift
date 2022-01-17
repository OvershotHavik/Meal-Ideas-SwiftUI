//
//  MyIdeasView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MyIdeasView: View {
    @StateObject var vm : MyIdeasVM
    @EnvironmentObject var query: Query
    let columns = [GridItem(), GridItem()]
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                            getRandomMeals: $vm.getRandomMeals,
                            source: $vm.source)
                    
                    //                Spacer(minLength: UI.topViewOffsetSpacing)
                    
                    if vm.meals.isEmpty{
                        NoResultsView(message: "No meals found for your search. \nCreate a new one by tapping the edit icon")
                            .offset(y: UI.verticalSpacing)
                    }
                    
                    if vm.totalMealCount != 0{
                        Text("Meals found: \(vm.totalMealCount)")
                            .opacity(0.5)
                            .offset(y: 10)
                    }
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(vm.meals, id: \.self) {meal in
                            NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: meal,
                                                                                              favorited: vm.checkForFavorite(id: meal.userMealID,
                                                                                                                             favoriteArray: query.favoritesArray),
                                                                                              showingHistory: false))) {
                                MealCardView(mealPhoto: "",
                                             mealPhotoData: meal.mealPhoto,
                                             mealName: meal.mealName ?? "",
                                             favorited: vm.checkForFavorite(id: meal.userMealID,
                                                                            favoriteArray: query.favoritesArray),
                                             inHistory: vm.checkForHistory(id: meal.mealName,
                                                                           historyArray: query.historyArray))
                            }
                                                                                              .foregroundColor(.primary)
                        }
                    }
                    NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: vm.surpriseMeal,
                                                                                      favorited: vm.checkForFavorite(id: vm.surpriseMeal?.userMealID,
                                                                                                                     favoriteArray: query.favoritesArray),
                                                                                      showingHistory: false)),
                                   isActive: $vm.getRandomMeals) {EmptyView()}
                    


                    Spacer()
                    if vm.allResultsShown{
                        AllResultsShownText()
                    }
                }
            }
            .padding()
            .background(BackgroundGradientView())
            
            .navigationTitle(Text("Meal Ideas"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: EditMealsListView(vm: EditMealsListVM())) {
                        Image(systemName: "square.and.pencil")
                            .padding(.horizontal)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesListView(vm: FavoritesListVM(source: .myIdeas))) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                    }
                    NavigationLink(destination: HistoryListView(vm: HistoryListVM(source: .myIdeas))) {
                        Image(systemName: "book")
                            .foregroundColor(.primary)
                    }
                }
            }
//            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
//                print("Keyword: \(query.keyword)")
//
//            })
            
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in User Meals")
                if vm.getRandomMeals == true {
                    vm.filterMeals(query: "", queryType: .random)
                }
                
            })
            .onChange(of: query.queryType, perform: { newValue in
                switch query.queryType{
                case .random:
//                    vm.filterMeals(query: "", queryType: .random)
                    return
                case .category:
                    if query.selected == ""{
                        vm.alertItem = AlertContext.noSelection
                        return
                    }
                case .ingredient:
                    if query.selected == ""{
                        vm.alertItem = AlertContext.noSelection
                        return
                    }
                case .keyword:
                    vm.resetValues()
                    vm.checkQuery(query: query.keyword, queryType: .keyword)
                case .none:
                    return
                }

            })

            .onAppear {
                vm.surpriseMeal = nil
                query.getHistory()
                query.getFavorites()
            }
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK")))
            }
        }
        
        
        
        .navigationViewStyle(.stack)
    }
        
    
}
/*
 struct MyIdeasView_Previews: PreviewProvider {
 static var previews: some View {
 MyIdeasView(vm:MyIdeasVM())
 }
 }
 */
