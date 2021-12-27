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
    
    
    var body: some View {
        NavigationView{
            VStack{
                TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                        getMoreMeals: $vm.getMoreMeals)
                let columns = [GridItem(), GridItem()]
                ScrollView{
                    if vm.isLoading{
                        loadingView()
                    }
                    if vm.meals.isEmpty && vm.keywordResults.isEmpty && vm.isLoading == false{
                        NoResultsView(imageName: "Placeholder",
                                      message: "No meals found for your search")
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
                if query.queryType != .keyword{
                    vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
                }
            }
            .onAppear(perform: query.getHistory)
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK"), action: stopLoading))
            }
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })
            .onChange(of: vm.getMoreMeals, perform: { newValue in
                print("More meals tapped in spoon: \(query.queryType)")
                vm.checkQuery(query: query.keyword, queryType: query.queryType)
            })
        }
        
    }
    // MARK: - Stop Loading
    func stopLoading(){
        vm.isLoading = false
    }

}

struct SpoonView_Previews: PreviewProvider {
    static var previews: some View {
        SpoonView(vm: SpoonVM())
    }
}
