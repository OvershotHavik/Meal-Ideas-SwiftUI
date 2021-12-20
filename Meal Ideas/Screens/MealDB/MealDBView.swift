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

    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                            getMoreMeals: $vm.getMoreMeals)
                    let columns = [GridItem(), GridItem()]
                    if vm.isLoading{
                        loadingView()
                    }

                    ScrollView{
                        if vm.meals.isEmpty && vm.isLoading == false{
                            NoResultsView(imageName: "Placeholder",
                                          message: "No meals found for your search")
                        }
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(vm.meals, id: \.id) { meal in
                                NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: meal,
                                                                                                favorited: checkForFavorite(id: meal.id),
                                                                                                mealID: meal.id ?? "",
                                                                                                showingHistory: false))) {
                                    MealCardView(mealPhoto: meal.strMealThumb ?? "",
                                                 mealName: meal.strMeal ?? "",
                                                 favorited: checkForFavorite(id: meal.id),
                                                 inHistory: checkForHistory(id: meal.id))
                                }
                                .foregroundColor(.primary)
                            }
                        }
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
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
                    vm.checkQuery(query: query.keyword, queryType: .keyword)
                })
    //            .onAppear {
    //                vm.checkQuery(query: query.selected ?? "", queryType: query.query)
    //            }
                //not sure what the difference between these two are.. both work.. need to look into later
                .task{
                    vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
                }
                .onAppear(perform: query.getHistory)
            }
        }
    }
    // MARK: - Stop Loading
    func stopLoading(){
        vm.isLoading = false
    }
    // MARK: - Check For Favorite
    func checkForFavorite(id: String?) -> Bool{
        if query.favoritesArray.contains(where: {$0.mealDBID == id}){
            print("favorited meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
    }
    // MARK: - Check FOr History
    func checkForHistory(id: String?) -> Bool{
        if query.historyArray.contains(where: {$0.mealDBID == id}){
            print("History meal id: \(id ?? "")")
            return true
        } else {
            return false
        }
    }
}

struct MealDBView_Previews: PreviewProvider {
    static var previews: some View {
        MealDBView(vm: MealDBVM())
    }
}
