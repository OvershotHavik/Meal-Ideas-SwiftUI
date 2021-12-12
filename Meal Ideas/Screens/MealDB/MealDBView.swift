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
    var test = true

    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    TopView(keywordSearchTapped: $vm.keywordSearchTapped)
                    let columns = [GridItem(), GridItem()]
                    if vm.isLoading{
                        loadingView()
                    }
                    ScrollView{
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(vm.meals, id: \.id) { meal in
                                NavigationLink(destination: MealDBDetailView(vm: MealDBDetailVM(meal: meal))) {
                                    MealCardView(mealPhoto: meal.strMealThumb ?? "",
                                                 mealName: meal.strMeal ?? "",
                                                 favorited: true,
                                                 inHistory: true)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .padding()

                }
                .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                    print("Keyword: \(query.keyword)")
                    vm.checkQuery(query: query.keyword, queryType: .keyword)
                })
    //            .onAppear {
    //                vm.checkQuery(query: query.selected ?? "", queryType: query.query)
    //            }
                //not sure what the difference between these two are.. both work.. need to look into later
                .task{
                    vm.checkQuery(query: query.selected ?? "", queryType: query.query)
                }


            }
        }
    }
}

struct MealDBView_Previews: PreviewProvider {
    static var previews: some View {
        MealDBView(vm: MealDBVM())
    }
}
