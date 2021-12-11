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

    var body: some View {
        NavigationView{
            VStack{
                TopView()
                let columns = [GridItem(), GridItem()]
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
            .onAppear {
                vm.checkQuery(query: query.selected ?? "", queryType: query.query)
//                vm.getRandomMeals()
            }
        }
    }
}

struct MealDBView_Previews: PreviewProvider {
    static var previews: some View {
        MealDBView(vm: MealDBVM())
    }
}
