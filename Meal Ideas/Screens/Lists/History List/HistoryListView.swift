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
            if vm.searchResults.isEmpty{
                NoResultsView(message: Messages.noHistory.rawValue)
                    .navigationBarTitle(Titles.history.rawValue)
            }
            ForEach(vm.searchResults) {history in
                switch vm.source{
                case .spoonacular:
                    NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: vm.fetchSpoonMeal(spoonID: history.spoonID),
                                                                                  mealID: Int(history.spoonID),
                                                                                  favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                                                                 id: "\(history.spoonID)",
                                                                                                                 userMealID: nil),
                                                                                  showingHistory: true))) {
                        HistoryCell(mealName: history.mealName ?? "",
                                    timeStamp: history.timeStamp,
                                    favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                   id: "\(history.spoonID)",
                                                                   userMealID: nil))
                    }
                                                                                  .navigationBarTitle(Titles.spoonHistory.rawValue)
                                                                                  .searchable(text: $vm.searchText)
                case .mealDB:
                    NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: vm.fetchMealDBMeal(mealDBID: history.mealDBID),
                                                                                    favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                                                                   id: history.mealDBID,
                                                                                                                   userMealID: nil),
                                                                                    mealID: history.mealDBID ?? "",
                                                                                    showingHistory: true))) {
                        HistoryCell(mealName: history.mealName ?? "",
                                    timeStamp: history.timeStamp,
                                    favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                   id: history.mealDBID,
                                                                   userMealID: nil))
                    }
                                                                                    .navigationBarTitle(Titles.mealDBHistory.rawValue)
                                                                                    .searchable(text: $vm.searchText)
                case .myIdeas:
                    NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: vm.fetchUserMeal(userMealID: history.userMealID),
                                                                                      favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                                                                     id: history.mealName,
                                                                                                                     userMealID: history.userMealID),
                                                                                      showingHistory: true))) {
                        HistoryCell(mealName: history.mealName ?? "",
                                    timeStamp: history.timeStamp,
                                    favorited: vm.checkForFavorite(favoritesArray: query.favoritesArray,
                                                                   id: history.mealName,
                                                                   userMealID: history.userMealID))
                    }
                                                                                      .navigationBarTitle(Titles.myIdeasHistory.rawValue)
                                                                                      .searchable(text: $vm.searchText)
                }
            }
            .onDelete{ IndexSet in
                PersistenceController.shared.deleteInList(indexSet: IndexSet,
                                                          entityName: .history)
                query.getHistory()
                vm.searchText = ""
                vm.filteredHistory(history: query.historyArray)
            }
        }
        
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button{
                    print("Trash tapped, process delete action sheet")
                    vm.deleteASPresented.toggle()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.blue)
                }
                .modifier(DeleteActionSheet(vm: vm))
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

// MARK: - Delete Action Sheet
struct DeleteActionSheet: ViewModifier{
    @ObservedObject var vm: HistoryListVM
    @EnvironmentObject var query: Query
    let all = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
    let oneDayAgoDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let oneWeekAgoDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    let sixtyDaysAgo = Calendar.current.date(byAdding: .day, value: -60, to: Date())!
    
    func body(content: Content) -> some View{
        content
            .actionSheet(isPresented: $vm.deleteASPresented) {
                var buttons = [ActionSheet.Button]()
                let delete1 = ActionSheet.Button.destructive(Text("Older than 1 Day")){
                    print("older than 1")
                    PersistenceController.shared.deleteHistory(source: vm.source,
                                                               deleteOption: oneDayAgoDate){
                        query.getHistory()
                        vm.filteredHistory(history: query.historyArray)
                    }
                }
                buttons.append(delete1)
                
                
                let delete7 = ActionSheet.Button.destructive(Text("Older than 7 Days")){
                    print("older than 7")
                    PersistenceController.shared.deleteHistory(source: vm.source,
                                                               deleteOption: oneWeekAgoDate){
                        query.getHistory()
                        vm.filteredHistory(history: query.historyArray)
                    }
                }
                buttons.append(delete7)
                
                
                let delete30 = ActionSheet.Button.destructive(Text("Older than 30 Days")){
                    print("older than 30")
                    PersistenceController.shared.deleteHistory(source: vm.source,
                                                               deleteOption: thirtyDaysAgo){
                        query.getHistory()
                        vm.filteredHistory(history: query.historyArray)
                    }
                }
                buttons.append(delete30)
                
                
                let delete60 = ActionSheet.Button.destructive(Text("Older than 60 Days")){
                    print("older than 60")
                    PersistenceController.shared.deleteHistory(source: vm.source,
                                                               deleteOption: sixtyDaysAgo){
                        query.getHistory()
                        vm.filteredHistory(history: query.historyArray)
                    }
                }
                buttons.append(delete60)
                
                
                let deleteAll = ActionSheet.Button.destructive(Text("All History")){
                    print("Delete all tapped")
                    PersistenceController.shared.deleteHistory(source: vm.source,
                                                               deleteOption: all){
                        query.getHistory()
                        vm.filteredHistory(history: query.historyArray)
                    }
                }
                buttons.append(deleteAll)
                
                
                buttons.append(.cancel())
                return ActionSheet(title: Text("Delete History for this source: "),
                                   message: nil,
                                   buttons: buttons)
            }
    }
}
