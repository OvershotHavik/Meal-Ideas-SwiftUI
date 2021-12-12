//
//  SpoonView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct SpoonView: View {
    @StateObject var vm : SpoonVM
    @State var keywordSearchTapped = false
    
    var body: some View {
        NavigationView{
            VStack{
                TopView(keywordSearchTapped: $keywordSearchTapped)
                let columns = [GridItem(), GridItem()]
                ScrollView{
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(vm.meals) { meal in
                            NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: meal))) {
                                MealCardView(mealPhoto: meal.image ?? "",
                                             mealName: meal.title,
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
                vm.getMeals()
            }
        }
    }
}

struct SpoonView_Previews: PreviewProvider {
    static var previews: some View {
        SpoonView(vm: SpoonVM())
    }
}
