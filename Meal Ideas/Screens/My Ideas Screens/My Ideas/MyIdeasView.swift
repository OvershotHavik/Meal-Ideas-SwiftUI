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
    
    var body: some View {
        NavigationView{
            GeometryReader{ screenBounds in
                ZStack(alignment: .top){
                    VStack(spacing: 10){
                        if vm.showWelcome{
                            NoResultsView(message: Messages.welcome.rawValue)
                                .frame(height: 500)
                        }
                        if vm.meals.isEmpty &&
                            vm.showWelcome == false &&
                            vm.isLoading == false{
                            NoResultsView(message: Messages.noMealsMyIdeas.rawValue)
                                .offset(y: UI.verticalSpacing)
                        }
                        TrackableScrollView(.vertical, contentOffset: $vm.scrollViewContentOffset){
                            Spacer(minLength: UI.topViewOffsetSpacing)
                            
                            VStack(spacing: 10){
                                if vm.meals.count != 0{
                                    Text("Meals shown: \(vm.meals.count)")
                                }
                                MyIdeasGrid(vm: vm)
                            }

                            //Only proceed if the user has created a meal, if not then an alert will be shown via the checkQuery function
                            if !vm.allMeals.isEmpty{
                                MyIdeaSurpriseNL(vm: vm)
                            }
                            //Bring up category view when selected in the menu
                            MenuCategoryNL(plist: nil,
                                           listItems: vm.userCategories)
                            
                            //Bring up ingredient view when selected in the menu
                            MenuIngredientsNL(userIngredients: vm.userIngredients)
                            
                            //Bring up the Custom filter view when selected in the menu
                            MenuCustomNL(source: .myIdeas,
                                         userIngredients: vm.userIngredients,
                                         userCategories: vm.userCategories,
                                         plist: nil)
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
            }
            .padding(.bottom)
            .background(vm.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: EditMealsListView(vm: EditMealsListVM())) {
                        Image(systemName: "square.and.pencil")
                            .padding(.horizontal)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .principal, content: {
                    Text(Titles.mainTitle.rawValue)
                })
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
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK")))
            }
            .onAppear {
                query.getHistory()
                query.getFavorites()
                vm.surpriseMeal = nil
                vm.getAllMeals() // updates the meals if the user created/deleted and came back
                if query.queryType == vm.originalQueryType && query.selected == vm.originalQuery{
                    //nothing changed, don't do anything
                    return
                }
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
                
                if query.queryType == .none ||
                    query.queryType == .random{
                    return
                } else {
                    vm.showWelcome = false
                    vm.checkQuery(query: query.selected, queryType: query.queryType)
                }
            }
            .onChange(of: vm.scrollViewContentOffset, perform: { newValue in
                vm.autoHideTopView()
            })
            .onChange(of: query.showAllUserMealIdeas, perform: { newValue in
                if query.showAllUserMealIdeas == true{
                    vm.showAllMeals()
                }
            })
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                query.selected = query.keyword
                vm.checkQuery(query: query.selected, queryType: query.queryType)
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in User Meals")
                if vm.getRandomMeals == true {
                    vm.checkQuery(query: query.selected, queryType: query.queryType)
                }
            })
        }
        .accentColor(.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// MARK: - My Ideas Surprise NL
struct MyIdeaSurpriseNL: View{
    //Used for surprise me, when get random meals is toggled it will take user directly to the first meal at random that they have created
    @EnvironmentObject var query: Query
    @StateObject var vm: MyIdeasVM
    var body: some View{
        NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: vm.surpriseMeal,
                                                                          favorited: vm.checkForFavorite(id: vm.surpriseMeal?.userMealID,
                                                                                                         favoriteArray: query.favoritesArray),
                                                                          showingHistory: false)),
                       isActive: $vm.getRandomMeals) {EmptyView()}
    }
}
// MARK: - My Ideas Grid
struct MyIdeasGrid: View{
    @EnvironmentObject var query: Query
    @StateObject var vm: MyIdeasVM
    var body: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], alignment: .center) {
            ForEach(vm.meals.indices, id: \.self) {mealIndex in
                let meal = vm.meals[mealIndex]
                NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: meal,
                                                                                  favorited: vm.checkForFavorite(id: meal.userMealID,
                                                                                                                 favoriteArray: query.favoritesArray),
                                                                                  showingHistory: false))) {
                    MealCardView(mealPhoto: "",
                                 mealPhotoData: meal.mealPhoto,
                                 mealName: meal.mealName ?? "",
                                 favorited: vm.checkForFavorite(id: meal.userMealID,
                                                                favoriteArray: query.favoritesArray),
                                 inHistory: vm.checkForHistory(id: meal.userMealID,
                                                               historyArray: query.historyArray))
                }
                                                                                  .foregroundColor(.primary)
            }
        }
    }
}
