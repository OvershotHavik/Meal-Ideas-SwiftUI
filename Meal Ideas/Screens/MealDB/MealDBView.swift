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
                            LazyVGrid(columns: columns, alignment: .center) {
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
                        //Used for surprise me, when get random meals is toggled it will take user directly to the first meal at random that they have created
                        NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.surpriseMeal,
                                                                                        favorited: vm.checkForFavorite(id: vm.surpriseMeal?.id,
                                                                                                                       favoriteArray: query.favoritesArray),
                                                                                        mealID: vm.surpriseMeal?.id ?? "",
                                                                                          showingHistory: false)),
                                       isActive: $vm.surpriseMealReady) {EmptyView()}
                        
                        //Bring up category view when selected in the menu
                        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: .mealDBCategories, listItems: [], singleChoiceString: query.selected, title: .oneCategory)),
                                       tag: QueryType.category,
                                       selection: $query.menuSelection) {EmptyView()}
                        
                        //Bring up ingredient view when selected in the menu
                        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: [], selection: query.selected)),
                                       tag: QueryType.ingredient,
                                       selection: $query.menuSelection) { EmptyView()}
                        
                        //bring up the custom filter view
                        NavigationLink(destination: CustomFilterView(vm: CustomFilterVM(source: .mealDB,
                                                                                        plist: .mealDBCategories,
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
                if query.queryType == vm.originalQueryType && query.selected == vm.originalQuery{
                    //nothing changed, don't do anything
                    return
                }
                query.getHistory()
                query.getFavorites()
                vm.surpriseMeal = nil
                
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
                    if query.queryType == .category{
                        //Only do this check if the query type is categories
                        if !vm.sourceCategories.contains(query.customCategory) &&
                            query.customCategory != ""{
                            //If the user selected a category that isn't supported, return with no meals
                            vm.resetValues()
                            vm.meals = []
                            vm.showWelcome = false
    //                        vm.alertItem = AlertContext.invalidData
                            return
                        }
                    }
                    vm.showWelcome = false
                    vm.checkQuery(query: query.selected, queryType: query.queryType)
                }
            }
            .onChange(of: vm.scrollViewContentOffset, perform: { newValue in
                vm.autoHideTopView()
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

