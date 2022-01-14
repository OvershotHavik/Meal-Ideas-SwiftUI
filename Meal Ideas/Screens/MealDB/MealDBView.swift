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
                
                if vm.meals.isEmpty && vm.isLoading == false{
                    NoResultsView(message: "No meals found for your search")
                        .offset(y: UI.verticalSpacing)
                    
                }
                ScrollView{
                    VStack{
                        if vm.totalMealCount != 0{
                            Text("Meals found: \(vm.totalMealCount)")
                                .opacity(0.5)
                                .offset(y: 10)
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
                                                                                                .onAppear{
                                                                                                    if mealIndex == vm.meals.count  - 2 {
                                                                                                        if query.queryType == .random{
                                                                                                            vm.checkQuery(query: query.selected, queryType: query.queryType)
                                                                                                        }
                                                                                                    }

                                                                                                }
                            }
                        }
                        Spacer()
                        if vm.isLoading{
                            loadingView()
                        }
                        if vm.allResultsShown{
                            AllResultsShownText()
                        }
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

            .onAppear{
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

