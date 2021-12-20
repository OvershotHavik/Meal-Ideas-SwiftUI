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
                    // TODO:  Fix the favorited to check
                    NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.fetchMealDBMeal(mealDBID: history.mealDBID),
                                                                                    favorited: false,
                                                                                    mealID: history.mealDBID ?? "",
                                                                                    showingHistory: true))) {
                        Text(history.mealName ?? "")
                    }
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
