//
//  SpoonView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct SpoonView: View {
    @StateObject var vm : SpoonVM
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
                            if vm.totalMealCount != 0{
                                if vm.moreToShow == true{
                                    //Only show when there are more available. Sometimes the total count is showing 1,000's but only brings back less than 10
                                    Text("Total Meals found: \(vm.totalMealCount)") // total meals for the complex search on the server
                                }
                            }
                            if vm.meals.count != 0{
                                Text("Meals shown: \(vm.meals.count)") // total meals that have loaded
                            }
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], alignment: .center) {
                                
                                ForEach(vm.meals.indices, id: \.self) { mealIndex in
                                    let meal = vm.meals[mealIndex]
                                    NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: meal,
                                                                                                  mealID: nil,
                                                                                                  favorited: vm.checkForFavorite(id: meal.id,
                                                                                                                                 favoriteArray: query.favoritesArray),
                                                                                                  showingHistory: false))) {
                                        MealCardView(mealPhoto: meal.image ?? "",
                                                     mealName: meal.title,
                                                     favorited: vm.checkForFavorite(id: meal.id,
                                                                                    favoriteArray: query.favoritesArray),
                                                     inHistory: vm.checkForHistory(id: meal.id,
                                                                                   historyArray: query.historyArray))
                                    }
                                                                                                  .foregroundColor(.primary)
                                                                                                  .onAppear{
                                                                                                      //                                                                                                      print("mealIndex: \(mealIndex)")
                                                                                                      if query.queryType != .random && vm.moreToShow{
                                                                                                          if mealIndex == vm.meals.count - 1 {
                                                                                                              if query.queryType == .custom{
                                                                                                                  vm.customFilter(keyword: query.customKeyword,
                                                                                                                                  category: query.customCategory,
                                                                                                                                  ingredient: query.customIngredient)
                                                                                                              } else {
                                                                                                                  print("check query called")
                                                                                                                  vm.checkQuery(query: query.selected, queryType: query.queryType)
                                                                                                              }
                                                                                                          }
                                                                                                      }
                                                                                                  }
                                }
                            }
                        }
                        
                        //Used for surprise me, when get random meals is toggled it will take user directly to the first meal at random that they have created
                        NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: vm.surpriseMeal,
                                                                                      mealID: vm.surpriseMeal?.id, favorited: vm.checkForFavorite(id: vm.surpriseMeal?.id,
                                                                                                                                                  favoriteArray: query.favoritesArray),
                                                                                      showingHistory: false)),
                                       isActive: $vm.surpriseMealReady) {EmptyView()}
                        
                        //Bring up category view when selected in the menu
                        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: .spoonCategories, listItems: [], singleChoiceString: query.selected, title: .oneCategory)),
                                       tag: QueryType.category,
                                       selection: $query.menuSelection) {EmptyView()}
                        
                        //Bring up ingredient view when selected in the menu
                        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: [], selection: query.selected)),
                                       tag: QueryType.ingredient,
                                       selection: $query.menuSelection) { EmptyView()}
                        
                        //bring up the custom filter view
                        NavigationLink(destination: CustomFilterView(vm: CustomFilterVM(source: .spoonacular,
                                                                                        plist: .spoonCategories,
                                                                                        userIngredients: [],
                                                                                        userCategories: [])),
                                       tag: QueryType.custom,
                                       selection: $query.menuSelection)  { EmptyView()}
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
                    NavigationLink(destination: FavoritesListView(vm: FavoritesListVM(source: .spoonacular))) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                    }
                    NavigationLink(destination: HistoryListView(vm: HistoryListVM(source: .spoonacular))) {
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
            .onAppear {
                query.getHistory()
                query.getFavorites()
                vm.surpriseMeal = nil
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
                vm.resetValues()
                
                if query.queryType == .custom{
                    if !vm.sourceCategories.contains(query.customCategory) &&
                        query.customCategory != ""{
                        //If the user selected a category that isn't supported, return with the error
                        vm.meals = []
                        vm.showWelcome = false
                        return
                    } else {
                        vm.customFilter(keyword: query.customKeyword,
                                        category: query.customCategory,
                                        ingredient: query.customIngredient)
                        return
                    }
                }
                if query.queryType == .none ||
                    query.queryType == .random{
                    return
                } else {
                    if !vm.sourceCategories.contains(query.customCategory) &&
                        query.customCategory != ""{
                        //If the user selected a category that isn't supported, return with no meals
                        vm.meals = []
                        vm.showWelcome = false
                        return
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
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                query.selected = query.keyword
                
                vm.checkQuery(query: query.selected, queryType: .keyword)
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in Spoon")
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
struct SpoonView_Previews: PreviewProvider {
    static var previews: some View {
        SpoonView(vm: SpoonVM(sourceCategory: .spoonCategories))
    }
}


