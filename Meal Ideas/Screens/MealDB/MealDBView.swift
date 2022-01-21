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
                        NoResultsView(message: "Welcome to Meal Ideas!")
                    }
                    
                    if vm.meals.isEmpty && vm.showWelcome == false && vm.isLoading == false{
                        NoResultsView(message: "No meals found for your search")
                            .offset(y: UI.verticalSpacing)
                    }
                    
                    
                    TrackableScrollView(.vertical, contentOffset: $vm.scrollViewContentOffset){
                        
                        Spacer(minLength: UI.topViewOffsetSpacing)
                        
                        VStack(spacing: 10){
                            if vm.meals.count != 0{
                                Text("Meals found: \(vm.meals.count)")
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
                        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: .categories), title: .oneCategory),
                                       tag: QueryType.category,
                                       selection: $query.menuSelection) {EmptyView()}
                        
                        //Bring up ingredient view when selected in the menu
                        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(editIdeaVM: EditIdeaVM(meal: nil))),
                                       tag: QueryType.ingredient,
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .background(BackgroundGradientView())
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
            
            .onChange(of: vm.scrollViewContentOffset, perform: { newValue in
                vm.autoHideTopView()
            })
            
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK"), action: stopLoading))
            }
            
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in mealDB")
                vm.checkQuery(query: query.selected, queryType: query.queryType)
            })
            
            .onAppear{
                vm.surpriseMeal = nil
                query.getHistory()
                query.getFavorites()
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
                
//                if query.queryType != .keyword{
//                }
                /*
                 if vm.isLoading == true {
                 return
                 }
                 if query.queryType == .category ||
                 query.queryType == .ingredient{
                 if query.selected == ""{
                 vm.alertItem = AlertContext.noSelection
                 return
                 }
                 }
                 if query.queryType != .keyword{
                 vm.resetValues()
                 vm.checkQuery(query: query.selected, queryType: query.queryType)
                 }
                 query.getHistory()
                 */
            }
            
        }
        
    }
    // MARK: - Stop Loading
    func stopLoading(){
        vm.isLoading = false
    }
    
}
// MARK: - Preview
struct MealDBView_Previews: PreviewProvider {
    static var previews: some View {
        MealDBView(vm: MealDBVM())
    }
}

