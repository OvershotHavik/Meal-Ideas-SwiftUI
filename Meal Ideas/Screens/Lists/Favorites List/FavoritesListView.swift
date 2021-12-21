//
//  FavoritesListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/19/21.
//

import SwiftUI

struct FavoritesListView: View {
    @StateObject var vm: FavoritesListVM
    @EnvironmentObject var query: Query
    
    var body: some View {
        
        List {
            ForEach(vm.searchResults) {favorite in
                switch vm.source {
                case .spoonacular:
                    NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: vm.fetchSpoonMeal(spoonID: favorite.spoonID),
                                                                                  mealID: Int(favorite.spoonID),
                                                                                  favorited: true,
                                                                                  showingHistory: false))) {
                        FavoriteCell(mealName: favorite.mealName)
                    }
                                                                                                                                                                    .navigationTitle(Titles.spoonFavorite.rawValue)
                                                                                                                                                                    .searchable(text: $vm.searchText)


                case .mealDB:
                    NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.fetchMealDBMeal(mealDBID: favorite.mealDBID),
                                                                                    favorited: true, mealID: favorite.mealDBID ?? "",
                                                                                    showingHistory: false))) {
                        FavoriteCell(mealName: favorite.mealName)
                    }
                                                                                    .navigationTitle(Titles.mealDBFavorite.rawValue)
                                                                                    .searchable(text: $vm.searchText)

                case .myIdeas:
                    NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: vm.fetchUserMeal(name: favorite.mealName),
                                                                                      favorited: true, showingHistory: false))) {
                        FavoriteCell(mealName: favorite.mealName)
                            .navigationTitle(Titles.myIdeasFavorite.rawValue)
                            .searchable(text: $vm.searchText)
                    }
                    
                }
            }
                                      .listStyle(.plain)
        }
        .onAppear {
            vm.filteredFavorites(favorites: query.favoritesArray)
        }
    }
}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesListView(vm: FavoritesListVM(source: .mealDB))
    }
}
