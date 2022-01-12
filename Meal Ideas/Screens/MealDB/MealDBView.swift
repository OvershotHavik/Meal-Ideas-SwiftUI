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
            VStack{
                TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                        getRandomMeals: $vm.getRandomMeals,
                        source: $vm.source)
                Spacer(minLength: UI.topViewOffsetSpacing)
                
                if vm.isLoading{
                    loadingView()
                        .offset(y: UI.verticalSpacing)
                }

                
                if let safeFirst = vm.tabData.first?.meals{
                    if safeFirst.isEmpty{
                        if vm.isLoading == false {
                            NoResultsView(message: "No meals found for your search")
                                .offset(y: UI.verticalSpacing)
                        }
                    }
                }
                if vm.totalMealCount != 0{
                    Text("Meals found: \(vm.totalMealCount)")
                        .opacity(0.5)
                        .offset(y: 10)
                }
                
                TabView(selection: $vm.selectedTab){
                    ForEach(vm.tabData) { tabItem in
                        ScrollView{
                            LazyVGrid(columns: columns, alignment: .center) {
                                ForEach(tabItem.meals) { meal in
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
                            .offset(y: UI.verticalSpacing )
                            
                            if vm.moreToShow == true &&
                                vm.isLoading == false{
                                MoreMealsButton(vm: vm)
                            }
                            
                        }
                        .tag(tabItem.tag)
                        .offset(y: -25)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                //                    .padding(.horizontal)
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: FavoritesListView(vm: FavoritesListVM(source: .mealDB))) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                        }
                        NavigationLink(destination: HistoryListView(vm: HistoryListVM(source: .mealDB))) {
                            Image(systemName: "book")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))

            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK"), action: stopLoading))
            }
            
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                vm.resetValues()
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in mealDB")
                vm.resetValues()
                vm.checkQuery(query: "", queryType: .random)
            })
            .onChange(of: vm.getMoreMeals, perform: { newValue in
                print("More meals tapped in mealDB: \(query.queryType)")
                //                    vm.getMoreTapped()
                if vm.getMoreMeals == true {
                    vm.getMore()
                }
//                if query.queryType == .keyword{
//                    vm.checkQuery(query: query.keyword, queryType: .keyword)
//                } else {
//                    vm.checkQuery(query: query.selected , queryType: query.queryType)
//                }
                //                    vm.checkQuery(query: query.keyword, queryType: query.queryType)
            })
            //            .onAppear {
            //                vm.checkQuery(query: query.selected ?? "", queryType: query.query)
            //            }
            //not sure what the difference between these two are.. both work.. need to look into later
            .onAppear{
                if query.queryType == vm.originalQueryType && query.selected == vm.originalQuery {
                    //nothing changed, don't do anything
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
                    vm.checkQuery(query: query.selected , queryType: query.queryType)
                }
                query.getHistory()
            }
            
        }
        .navigationViewStyle(.stack)
        
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

