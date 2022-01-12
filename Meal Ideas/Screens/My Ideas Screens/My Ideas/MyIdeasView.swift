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
//                        .offset(y: -20)
                    
                    Spacer(minLength: UI.topViewOffsetSpacing)
                    
                    if vm.meals.isEmpty{
                        NoResultsView(message: "No meals found for your search. \nCreate a new one by tapping the edit icon")
                            .offset(y: UI.verticalSpacing)
                    }
                    ScrollView{
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(vm.meals) {meal in
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
                        
                        .offset(y: UI.verticalSpacing)
                        if vm.lessThanTen == true {
                            MoreMealsButton(vm: vm)
                        }
                        
                        
                    }
                    
                    .padding()
                }
            }
            .ignoresSafeArea()
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
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                vm.offsetBy = 0
                vm.lessThanTen = false
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })
            
            .onChange(of: vm.allMeals, perform: { newValue in
                //if user changed the meals, run it again
                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in User Meals")
                vm.filterMeals(query: "", queryType: .random)
            })
            .onChange(of: vm.getMoreMeals, perform: { newValue in
                print("Get more meals in user meals")
                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
            })
            .onAppear {
                if query.queryType == .category ||
                    query.queryType == .ingredient{
                    if query.selected == nil{
                        vm.alertItem = AlertContext.noSelection
                        return
                    }
                }
                vm.getAllMeals()
                if query.queryType != .keyword{
                    vm.offsetBy = 0
                    vm.lessThanTen = false
                    vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
                }
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
