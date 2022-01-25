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
            ZStack(alignment: .top){
                VStack(spacing: 10){
                    if vm.showWelcome{
                        NoResultsView(message: "Welcome to Meal Ideas!")
                    }

                    if vm.meals.isEmpty && vm.showWelcome == false{
                        NoResultsView(message: "No meals found for your search. \nCreate a new one by tapping the edit icon")
                            .offset(y: UI.verticalSpacing)
                    }

                    TrackableScrollView(.vertical, contentOffset: $vm.scrollViewContentOffset){
                        Spacer(minLength: UI.topViewOffsetSpacing)

                        VStack(spacing: 10){
                            if vm.meals.count != 0{
                                Text("Meals shown: \(vm.meals.count)")
                            }
                            LazyVGrid(columns: columns, alignment: .center) {
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

                        //Used for surprise me, when get random meals is toggled it will take user directly to the first meal at random that they have created
                        NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: vm.surpriseMeal,
                                                                                          favorited: vm.checkForFavorite(id: vm.surpriseMeal?.userMealID,
                                                                                                                         favoriteArray: query.favoritesArray),
                                                                                          showingHistory: false)),
                                       isActive: $vm.getRandomMeals) {EmptyView()}

                        //Bring up category view when selected in the menu
                        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: nil, listItems: vm.userCategories, singleChoiceString: query.selected), title: .oneCategory),
                                       tag: QueryType.category,
                                       selection: $query.menuSelection) {EmptyView()}

                        //Bring up ingredient view when selected in the menu
                        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(itemList: vm.userIngredients)),
                                       tag: QueryType.ingredient,
                                       selection: $query.menuSelection) { EmptyView()}
                        
                        //Bring up the Custom filter view
                        NavigationLink(destination: CustomFilterView(vm: CustomFilterVM(source: .myIdeas,
                                                                                        plist: nil,
                                                                                        userIngredients: vm.userIngredients,
                                                                                        userCategories: vm.userCategories)),
                                       tag: QueryType.custom,
                                       selection: $query.menuSelection) { EmptyView()}

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
//                        .background(BackgroundGradientView())
                }
            }
//            .background(BackgroundGradientView())
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
                vm.surpriseMeal = nil
                query.getHistory()
                query.getFavorites()
                vm.surpriseMeal = nil

                if query.queryType == .none ||
                    query.queryType == .random{
                    return
                }
                if query.queryType == .category ||
                    query.queryType == .ingredient{
                    if query.selected == ""{
                        vm.alertItem = AlertContext.noSelection
                        return
                    }
                    vm.checkQuery(query: query.selected, queryType: query.queryType)
                }
                
                if query.queryType == .keyword{
                    vm.checkQuery(query: query.selected, queryType: query.queryType)
                }
                
                if query.queryType == .custom{
                    vm.customFilter(keyword: query.customKeyword,
                                    category: query.customCategory,
                                    ingredient: query.customIngredient)
                }
            }

            
            .onChange(of: vm.scrollViewContentOffset, perform: { newValue in
                vm.autoHideTopView()
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
    }
    
    
}
/*
 struct MyIdeasView_Previews: PreviewProvider {
 static var previews: some View {
 MyIdeasView(vm:MyIdeasVM())
 }
 }
 */
