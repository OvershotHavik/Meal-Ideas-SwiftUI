//
//  MealDBView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MealDBView: View {
    @StateObject var vm: MealDBVM
    @EnvironmentObject var query: Query
    @EnvironmentObject var userEnvironment: UserEnvironment
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
                VStack(spacing: 10){
                    if vm.showWelcome{
                        NoResultsView(message: Messages.welcome.rawValue)
                            .frame(height: 500)
                    }
                    
                    if vm.meals.isEmpty && vm.showWelcome == false && vm.isLoading == false{
                        NoResultsView(message: Messages.noMealsFound.rawValue)
                            .offset(y: UI.verticalSpacing)
                    }
                    
                    TrackableScrollView(.vertical, contentOffset: $vm.scrollViewContentOffset){
                        
                        Spacer(minLength: UI.topViewOffsetSpacing)
                        
                        VStack(spacing: 10){
                            if vm.meals.count != 0{
                                Text("Meals shown: \(vm.meals.count)")
                            }
                            MealDBGrid(vm: vm)
                        }
                        //Used for surprise meal to bring up a random meal
                        MealDBSurpriseNL(vm: vm)
                        
                        //Bring up category view when selected in the menu
                        MenuCategoryNL(plist: .mealDBCategories,
                                       listItems: [])
                        
                        //Bring up ingredient view when selected in the menu
                        MenuIngredientsNL(userIngredients: [])
                        
                        //Bring up the Custom filter view when selected in the menu
                        MenuCustomNL(source: .mealDB,
                                     userIngredients: [],
                                     userCategories: [],
                                     plist: .mealDBCategories)
                        
                        Spacer()
                        
                        if vm.allResultsShown{
                            AllResultsShownText()
                        }
                    }
                }
                if vm.isLoading{
                    loadingView()
                }
                if vm.showTopView{
                    TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                            getRandomMeals: $vm.getRandomMeals,
                            source: $vm.source)
                }
            }
            .padding(.bottom)
            .background(vm.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .principal, content: {
                    Text(Titles.mainTitle.rawValue)
                    .foregroundColor(userEnvironment.topLeftColor.isLight() ? Color.black : Color.white)
                })
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    NavigationLink(destination: FavoritesListView(vm: FavoritesListVM(source: .mealDB))) {
                        Image(systemName: SFSymbols.favorited.rawValue)
                            .foregroundColor(.pink)
                    }
                    NavigationLink(destination: HistoryListView(vm: HistoryListVM(source: .mealDB))) {
                        Image(systemName: SFSymbols.history.rawValue)
                            .foregroundColor(userEnvironment.bottomRightColor.isLight() ? Color.black : Color.white)
                    }
                }
            }
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK"), action: stopLoading))
            }
            .onAppear{
                query.getHistory()
                query.getFavorites()
                vm.surpriseMeal = nil

                vm.sourceOnAppear(queryType: query.queryType,
                                  selected: query.selected,
                                  customKeyword: query.customKeyword,
                                  customCategory: query.customCategory,
                                  customIngredient: query.customIngredient){}
            }
            .onChange(of: vm.scrollViewContentOffset, perform: { newValue in
                vm.autoHideTopView()
            })
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                query.selected = query.keyword
                vm.checkQuery(query: query.keyword, queryType: .keyword){}
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in mealDB")
                vm.checkQuery(query: query.selected, queryType: query.queryType){}
            })
        }
        .accentColor(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }


    func stopLoading(){
        vm.isLoading = false
    }
}


private struct MealDBSurpriseNL: View{
    @EnvironmentObject var query: Query
    @EnvironmentObject var shopping: Shopping
    @StateObject var vm: MealDBVM
    
    var body: some View{
        NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.surpriseMeal,
                                                                        favorited: vm.checkForFavorite(id: vm.surpriseMeal?.id,
                                                                                                       favoriteArray: query.favoritesArray),
                                                                        mealID: vm.surpriseMeal?.id ?? "",
                                                                        showingHistory: false)),
                       isActive: $vm.surpriseMealReady) {EmptyView()}
                       .environmentObject(shopping)

    }
}


private struct MealDBGrid: View{
    @EnvironmentObject var query: Query
    @EnvironmentObject var shopping: Shopping
    @StateObject var vm: MealDBVM
    
    var body: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], alignment: .center) {
            ForEach(vm.meals.indices, id: \.self) { mealIndex in
                let meal = vm.meals[mealIndex]
                NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: meal,
                                                                                favorited: vm.checkForFavorite(id: meal.id,
                                                                                                               favoriteArray: query.favoritesArray),
                                                                                mealID: meal.id ?? "",
                                                                                showingHistory: false))) {
                    MealCardView(mealPhoto: meal.strMealThumb ?? "",
                                 mealName: meal.strMeal ?? "",
                                 favorited: vm.checkForFavorite(id: meal.id,
                                                                favoriteArray: query.favoritesArray),
                                 inHistory: vm.checkForHistory(id: meal.id,
                                                               historyArray: query.historyArray))
                        .environmentObject(shopping)

                }
                                                                                .foregroundColor(.primary)
            }
        }
    }
}
