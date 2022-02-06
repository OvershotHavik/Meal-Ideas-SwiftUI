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
    let columns = [GridItem(), GridItem()]
    
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
                })
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    NavigationLink(destination: FavoritesListView(vm: FavoritesListVM(source: .mealDB))) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                    }
                    NavigationLink(destination: HistoryListView(vm: HistoryListVM(source: .mealDB))) {
                        Image(systemName: "book")
                            .foregroundColor(.primary)
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

                if query.queryType == .category ||
                    query.queryType == .ingredient{
                    if query.selected == ""{
                        //nothing selected, if we let it go it brings back random results
                        return
                    }
                }
                
                if query.queryType == .custom{
                    vm.customFilter(keyword: query.customKeyword,
                                    category: query.customCategory,
                                    ingredient: query.customIngredient)
                    return
                }
                if query.queryType == vm.originalQueryType && query.selected == vm.originalQuery{
                    //nothing changed, don't do anything
                    return
                }
                if query.queryType == .none ||
                    query.queryType == .random{
                    return
                } else {
                    if query.queryType == .category{
                        //Only do this check if the query type is categories
                        if !vm.sourceCategories.contains(query.customCategory) &&
                            query.customCategory != ""{
                            //If the user selected a category that isn't supported, return with no meals
                            vm.resetValues()
                            vm.meals = []
                            vm.showWelcome = false
                            return
                        }
                    }
                    vm.showWelcome = false
                    vm.checkQuery(query: query.selected, queryType: query.queryType)
                }
            }
            .onChange(of: vm.isLoading, perform: { _ in
                vm.stopLoading()
            })
            .onChange(of: vm.scrollViewContentOffset, perform: { newValue in
                vm.autoHideTopView()
            })
            .onChange(of: query.selected, perform: { _ in
                //Clears the grid so the pictures load correctly
                vm.meals = []
                vm.allResultsShown = false
            })
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                query.selected = query.keyword
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in mealDB")
                vm.checkQuery(query: query.selected, queryType: query.queryType)
            })
        }
        .accentColor(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    // MARK: - Stop Loading
    func stopLoading(){
        vm.isLoading = false
    }
}
// MARK: - Preview
struct MealDBView_Previews: PreviewProvider {
    static var previews: some View {
        MealDBView(vm: MealDBVM(sourceCategory: .mealDBCategories))
    }
}

// MARK: - MealDB Surprise NL
struct MealDBSurpriseNL: View{
    @EnvironmentObject var query: Query
    @StateObject var vm: MealDBVM
    var body: some View{
        NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.surpriseMeal,
                                                                        favorited: vm.checkForFavorite(id: vm.surpriseMeal?.id,
                                                                                                       favoriteArray: query.favoritesArray),
                                                                        mealID: vm.surpriseMeal?.id ?? "",
                                                                        showingHistory: false)),
                       isActive: $vm.surpriseMealReady) {EmptyView()}
    }
}
// MARK: - MealDB Grid
struct MealDBGrid: View{
    @EnvironmentObject var query: Query
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
                }
                                                                                .foregroundColor(.primary)
            }
        }
    }
}
