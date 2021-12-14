//
//  MyIdeasView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MyIdeasView: View {
    @StateObject var vm : MyIdeasVM
    @EnvironmentObject var query: Query
    
    var body: some View {
        NavigationView{
            VStack{
                TopView(keywordSearchTapped: $vm.keywordSearchTapped, getMoreMeals: $vm.getMoreMeals)
                let columns = [GridItem(), GridItem()]
                if vm.meals.isEmpty{
                    NoResultsView(imageName: "Placeholder",
                                  message: "No meals found for your search. Create a new one by tapping the edit icon")
                }
                ScrollView{
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(vm.meals) {meal in
                            NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: meal))) {
                                MealCardView(mealPhoto: "",
                                             mealPhotoData: meal.mealPhoto,
                                             mealName: meal.mealName ?? "",
                                             favorited: true,
                                             inHistory: true)
                            }
                            .foregroundColor(.primary)
                        }
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
            }
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })
            .onChange(of: vm.getMoreMeals, perform: { newValue in
                print("more meals tapped for: \(query.queryType.rawValue)")
                vm.checkQuery(query: query.keyword, queryType: query.queryType)
            })
            .onAppear {
                print("on appear")
                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
            }
            //not sure what the difference between these two are.. both work.. need to look into later
//            .task{
//                print("task")
//                vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
//            }


        }
    }
}
/*
struct MyIdeasView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasView(vm:MyIdeasVM())
    }
}
*/
