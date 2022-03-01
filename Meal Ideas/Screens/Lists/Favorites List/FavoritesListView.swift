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
        if vm.searchResults.isEmpty{
            NoResultsView(message: Messages.noFavorites.rawValue)
                .navigationTitle(Titles.favorites.rawValue)
        }
        List {
            ForEach(vm.searchResults) {favorite in
                switch vm.source {
                case .spoonacular:
                    SpoonacularFavoritesNL(vm: vm, favorite: favorite)
                    
                case .mealDB:
                    MealDBFavoritesNL(vm: vm, favorite: favorite)
                    
                case .myIdeas:
                    MyIdeasFavoritesNL(vm: vm, favorite: favorite)
                }
            }
            .onDelete{ IndexSet in
                PersistenceController.shared.deleteInList(indexSet: IndexSet,
                                                          entityName: .favorites,
                                                          source: vm.source)
                query.getFavorites()
                vm.filteredFavorites(favorites: query.favoritesArray)
            }
            .listStyle(.plain)
        }
        .searchable(text: $vm.searchText)
        .onAppear {
            vm.filteredFavorites(favorites: query.favoritesArray)
        }
    }
}


struct MyIdeasFavoritesNL: View{
    @StateObject var vm: FavoritesListVM
    @EnvironmentObject var query: Query
    var favorite: Favorites
    
    var body: some View{
        NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: vm.fetchUserMeal(userMealID: favorite.userMealID),
                                                                          favorited: true, showingHistory: false))) {
            FavoriteCell(mealName: favorite.mealName)
                .navigationTitle(Titles.myIdeasFavorite.rawValue)
        }
    }
}


struct MealDBFavoritesNL: View{
    @StateObject var vm: FavoritesListVM
    @EnvironmentObject var query: Query
    var favorite: Favorites
    
    
    var body: some View{
        NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.fetchMealDBMeal(mealDBID: favorite.mealDBID),
                                                                        favorited: true, mealID: favorite.mealDBID ?? "",
                                                                        showingHistory: false))) {
            FavoriteCell(mealName: favorite.mealName)
                .navigationTitle(Titles.mealDBFavorite.rawValue)
        }
    }
}


struct SpoonacularFavoritesNL: View{
    @StateObject var vm: FavoritesListVM
    @EnvironmentObject var query: Query
    var favorite: Favorites
    
    
    var body: some View{
        NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: vm.fetchSpoonMeal(spoonID: favorite.spoonID),
                                                                      mealID: Int(favorite.spoonID),
                                                                      favorited: true,
                                                                      showingHistory: false))) {
            FavoriteCell(mealName: favorite.mealName)
                .navigationTitle(Titles.spoonFavorite.rawValue)
        }
    }
}
