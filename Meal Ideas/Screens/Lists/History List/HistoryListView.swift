//
//  HistoryListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/19/21.
//

import SwiftUI

struct HistoryListView: View {
    @StateObject var vm: HistoryListVM
    @EnvironmentObject var query: Query
    
    var body: some View {
        List {
            ForEach(vm.searchResults) {history in
                switch vm.source{
                case .spoonacular:
                    Text(vm.source.rawValue)
                case .mealDB:
                    NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.fetchMealDBMeal(mealDBID: history.mealDBID),
                                                                                    favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                                                                   id: history.mealDBID),
                                                                                    mealID: history.mealDBID ?? "",
                                                                                    showingHistory: true))) {
                        HistoryCell(mealName: history.mealName ?? "",
                                    timeStamp: history.timeStamp,
                                    favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                   id: history.mealDBID))
                    }
                                                                                    .navigationTitle(Titles.mealDBHistory.rawValue)
                case .myIdeas:
                    Text(vm.source.rawValue)
                }
            }
        }
        .onAppear {
            vm.filteredHistory(history: query.historyArray)
        }
        
    }

}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView(vm: HistoryListVM(source: .myIdeas))
    }
}
