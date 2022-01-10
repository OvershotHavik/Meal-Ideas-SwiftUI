//
//  MyIdeasView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

import SwiftUI
struct TabItem2: Identifiable {
    var id = UUID()
//    var title: Text
//    var image: Image
//    var tag: Int
}
/*
struct ContentView: View {
    @StateObject var vm = MyIdeasVM()
//    @State private var selectedTab = 0
    let columns = [GridItem(), GridItem()]
    @EnvironmentObject var query: Query
    init(){
//        vm.checkQuery(query: "", queryType: .random)
    }
    var body: some View {

        TabView() {

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
                }

            }
        }
        .tabViewStyle(.page)
//        .indexViewStyle(.page(backgroundDisplayMode: .automatic))
        .onAppear{
            vm.checkQuery(query: "", queryType: .random)
        }
    }
        
}
*/






struct MyIdeasView: View {
    @StateObject var vm : MyIdeasVM
    @EnvironmentObject var query: Query
    let columns = [GridItem(), GridItem()]

    
    var body: some View {
        NavigationView{
            VStack{
                TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                        getRandomMeals: $vm.getRandomMeals,
                        source: $vm.source)
                
                Spacer(minLength: UI.topViewOffsetSpacing)
                
                if vm.meals.isEmpty{
//                if vm.tabData[0].meals.count == 0{
                    NoResultsView(message: "No meals found for your search. \nCreate a new one by tapping the edit icon")
                        .offset(y: UI.verticalSpacing)
                }
                TabView{

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
//                            if vm.lessThanTen == true {
//                                MoreMealsButton(vm: vm)
//                            }
                        }
                    }
                }
                .padding()
            }
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
                vm.offsetBy = 0
                vm.lessThanTen = false
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })

            .onChange(of: vm.allMeals, perform: { newValue in
                //if user changed the meals, run it again
                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
            })
            .onChange(of: vm.getRandomMeals, perform: { newValue in
                print("Random tapped in User Meals")
                vm.filterMeals(query: "", queryType: .random)
            })
            .onChange(of: vm.getMoreMeals, perform: { newValue in
                print("Get more meals in user meals")
                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
            })
            .onAppear {
                if query.queryType == .category ||
                    query.queryType == .ingredient{
                    if query.selected == nil{
                        vm.alertItem = AlertContext.noSelection
                        return
                    }
                }
                vm.getAllMeals()
                if query.queryType != .keyword{
                    vm.offsetBy = 0
                    vm.lessThanTen = false
                    vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
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





/*
 
 struct MyIdeasView: View {
     @StateObject var vm : MyIdeasVM
     @EnvironmentObject var query: Query
     let columns = [GridItem(), GridItem()]
     var body: some View {
         NavigationView{
             VStack{
                 TopView(keywordSearchTapped: $vm.keywordSearchTapped,
                         getRandomMeals: $vm.getRandomMeals,
                         source: $vm.source)
                 
                 Spacer(minLength: UI.topViewOffsetSpacing)
                 
                 if vm.meals.isEmpty{
                     NoResultsView(message: "No meals found for your search. \nCreate a new one by tapping the edit icon")
                         .offset(y: UI.verticalSpacing)
                 }
                 ScrollView{
                     LazyVGrid(columns: columns, alignment: .center) {
                         ForEach(vm.meals) {meal in
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
                     if vm.lessThanTen == true {
                         MoreMealsButton(vm: vm)
                     }


                 }
                 
                 .padding()
             }
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
                 vm.offsetBy = 0
                 vm.lessThanTen = false
                 vm.checkQuery(query: query.keyword, queryType: .keyword)
             })

             .onChange(of: vm.allMeals, perform: { newValue in
                 //if user changed the meals, run it again
                 vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
             })
             .onChange(of: vm.getRandomMeals, perform: { newValue in
                 print("Random tapped in User Meals")
                 vm.filterMeals(query: "", queryType: .random)
             })
             .onChange(of: vm.getMoreMeals, perform: { newValue in
                 print("Get more meals in user meals")
                 vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
             })
             .onAppear {
                 if query.queryType == .category ||
                     query.queryType == .ingredient{
                     if query.selected == nil{
                         vm.alertItem = AlertContext.noSelection
                         return
                     }
                 }
                 vm.getAllMeals()
                 if query.queryType != .keyword{
                     vm.offsetBy = 0
                     vm.lessThanTen = false
                     vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
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
 */
