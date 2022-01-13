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
            VStack{
                TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                        getRandomMeals: $vm.getRandomMeals,
                        source: $vm.source)
                Spacer(minLength: UI.topViewOffsetSpacing)
                ScrollView{
//                    if vm.isLoading{
//                        loadingView()
////                            .offset(y: UI.verticalSpacing)
//                    }
                    if vm.meals.isEmpty && vm.keywordResults.isEmpty && vm.isLoading == false{
                        NoResultsView(message: "No meals found for your search")
                            .offset(y: UI.verticalSpacing)
                    }
                    if vm.totalMealCount != 0{
                        Text("Meals found: \(vm.totalMealCount)")
                            .opacity(0.5)
                            .offset(y: 10)
                    }
                    if vm.keywordResults.isEmpty{
                        //Normal run through
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(vm.meals) { meal in
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
                            }
                        }
                        .offset(y: UI.verticalSpacing)

                    } else {
                        //Keyword search, need to fetch the meal on the VM
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(vm.keywordResults) { meal in
                                NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: nil,
                                                                                              mealID: meal.id,
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
                            }
                        }
                        .offset(y: UI.verticalSpacing)
                    }
                    if vm.isLoading == false && vm.moreToShow == true{
                        MoreMealsButton(vm: vm)
                    }
                    if vm.isLoading{
                        loadingView()
//                            .offset(y: UI.verticalSpacing)
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: FavoritesListView(vm: FavoritesListVM(source: .spoonacular))) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                        }
                        NavigationLink(destination: HistoryListView(vm: HistoryListVM(source: .spoonacular))) {
                            Image(systemName: "book")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .onAppear {
                if query.queryType == .category ||
                    query.queryType == .ingredient{
                    if query.selected == ""{
                        vm.alertItem = AlertContext.noSelection
                        return
                    }
                }
                if query.queryType != .keyword{
                    vm.offsetBy = 0 // may need changed to somewhere else
                    vm.checkQuery(query: query.selected , queryType: query.queryType)
                }
                query.getHistory()
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
                print("Random tapped in Spoon")
                vm.resetValues()
                vm.getRandomMeals()
            })
            .onChange(of: vm.getMoreMeals, perform: { newValue in
                print("More meals tapped in spoon: \(query.queryType)")
//                vm.resetValues()
                
                if query.queryType == .keyword{
                    vm.checkQuery(query: query.keyword, queryType: .keyword)
                } else {
//                    vm.resetValues()
                    vm.checkQuery(query: query.selected, queryType: query.queryType)
                }
            })

        }
        .navigationViewStyle(.stack)

        
    }
    // MARK: - Stop Loading
    func stopLoading(){
        vm.isLoading = false
    }

}
// MARK: - Preview
struct SpoonView_Previews: PreviewProvider {
    static var previews: some View {
        SpoonView(vm: SpoonVM())
    }
}

