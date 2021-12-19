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
    var source: Source
    
    var body: some View {
        List {
            ForEach(vm.filteredFavorites(favorites: query.favoritesArray,
                                      source: source)) {favorite in
                switch source {
                case .spoonacular:
                    Text(favorite.mealName ?? "")
                    //                    NavigationLink(destination: <#T##() -> _#>, label: <#T##() -> _#>)
                case .mealDB:
                    Text(favorite.mealName ?? "")
                case .myIdeas:
                    NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: vm.fetchFavorite(name: favorite.mealName),
                                                                                      favorited: true))) {
                        Text(favorite.mealName ?? "")
                    }
                }
                
            }
        }
    }


}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesListView(vm: FavoritesListVM(), source: .myIdeas)
    }
}
