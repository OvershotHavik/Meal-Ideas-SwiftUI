//
//  MyIdeasView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

import SwiftUI

struct MyIdeasView: View {
    @StateObject var vm :  MyIdeasVM
    @EnvironmentObject var query: Query
    let columns = [GridItem(), GridItem()]

    
    var body: some View {
        NavigationView{
            VStack{
                TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                        getRandomMeals: $vm.getRandomMeals,
                        source: $vm.source)
                
                Spacer(minLength: UI.topViewOffsetSpacing)
                
                if vm.noMealsFound == true{
                    NoResultsView(message: "No meals found for your search. \nCreate a new one by tapping the edit icon")
                        .offset(y: UI.verticalSpacing)
                }
                if vm.totalMealCount != 0{
                    Text("Meals found: \(vm.totalMealCount)")
                        .opacity(0.5)
                        .offset(y: 10)
                }
                
                TabView(selection: $vm.selectedTab){

                    ForEach(vm.tabData) { tabItem in
                        ScrollView{
                            LazyVGrid(columns: columns, alignment: .center) {

                                ForEach(tabItem.meals) {meal in
                                    NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: meal,
                                                                                                      favorited: vm.checkForFavorite(id: meal.userMealID,
                                                                                                                                     favoriteArray: query.favoritesArray),
                                                                                                      showingHistory: false))) {
                                        MealCardView(mealPhoto: "",
                                                     mealPhotoData: meal.mealPhoto,
                                                     mealName: meal.mealName ?? "",
                                                     favorited: vm.checkForFavorite(id: meal.userMealID,
                                                                                    favoriteArray: query.favoritesArray),
                                                     inHistory: vm.checkForHistory(id: meal.mealName,
                                                                                   historyArray: query.historyArray))
                                    }
                                    .foregroundColor(.primary)
                                }
                            }
                            .offset(y: UI.verticalSpacing)
                            if vm.moreToShow == true {
                                MoreMealsButton(vm: vm)
                            }
                        }
                        .tag(tabItem.tag)
                        .offset(y: -25)
                    }
                }
                .padding()
            }
//            .tabViewStyle(.page)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: EditMealsListView(vm: EditMealsListVM())) {
                        Image(systemName: "square.and.pencil")
                            .padding(.horizontal)
                            .foregroundColor(.black)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesListView(vm: FavoritesListVM(source: .myIdeas))) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                    }
                    NavigationLink(destination: HistoryListView(vm: HistoryListVM(source: .myIdeas))) {
                        Image(systemName: "book")
                            .foregroundColor(.black)
                    }
                }
            }
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                vm.resetValues()
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })

            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in User Meals")
                vm.resetValues()
                vm.filterMeals(query: "", queryType: .random)
            })
//            .onChange(of: query.queryType, perform: { newValue in
//                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
//            })
//            .onChange(of: query.selected, perform: { newValue in
//                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
//            })
            .onChange(of: vm.getMoreMeals, perform: { newValue in
                print("Get more meals in user meals")
                if vm.getMoreMeals == true{
                    vm.getMore()
                }
            })
            .onAppear {
                if query.queryType == vm.originalQueryType && query.selected == vm.originalQuery {
                    //nothing changed, don't do anything
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
                query.getFavorites()
            }

            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(.stack)

    }
    

}
/*
struct MyIdeasView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasView(vm:MyIdeasVM())
    }
}
*/
