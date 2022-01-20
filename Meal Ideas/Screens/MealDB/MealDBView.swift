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
            ZStack(alignment: .top){
                VStack(spacing: 10){
                    
                    if vm.meals.isEmpty && vm.isLoading == false{
                        NoResultsView(message: "No meals found for your search")
                            .offset(y: UI.verticalSpacing)
                        
                    }
                    TrackableScrollView(.vertical, contentOffset: $vm.scrollViewContentOffset){
                        
                        Spacer(minLength: UI.topViewOffsetSpacing)
                        
                        VStack(spacing: 10){
                            if vm.totalMealCount != 0{
                                Text("Meals found: \(vm.totalMealCount)")
                                    .opacity(0.5)
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
                }
                .navigationTitle(Text("Meal Ideas"))
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .background(BackgroundGradientView())
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
                if vm.showTopView{
                    TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                            getRandomMeals: $vm.getRandomMeals,
                            source: $vm.source)
                }
            }
            .onChange(of: vm.scrollViewContentOffset, perform: { newValue in
                
                withAnimation(.easeOut){
                    if vm.scrollViewContentOffset < UI.topViewOffsetSpacing{
                        vm.showTopView = true
                    } else {
                        vm.showTopView = false
                    }
                    
                    if vm.scrollViewContentOffset > vm.largestY{
                        //user is scrolling down
                        vm.largestY = vm.scrollViewContentOffset
                        
                    } else {
                        //user started scrolling up again, show the view and set largest Y to current value
                        vm.showTopView = true
                        vm.largestY = vm.scrollViewContentOffset
                    }
                }
                
                
                
                print("offset value: \(vm.scrollViewContentOffset)")
            })
            
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

