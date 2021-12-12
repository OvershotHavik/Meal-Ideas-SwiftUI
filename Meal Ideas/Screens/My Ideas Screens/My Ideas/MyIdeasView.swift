//
//  MyIdeasView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MyIdeasView: View {
    @ObservedObject var vm = MyIdeasVM()
    @State var keywordSearchTapped = false
    
    var body: some View {
        NavigationView{
            VStack{
                TopView(keywordSearchTapped: $keywordSearchTapped)
                let columns = [GridItem(), GridItem()]
                ScrollView{
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(vm.savedMeals) {meal in
                            NavigationLink(destination: MyIdeasDetailView(vm: MyIdeasDetailVM(meal: meal))) {
                                MealCardView(mealPhoto: "",
                                             mealPhotoData: meal.mealPhoto,
                                             mealName: meal.mealName ?? "",
                                             favorited: true,
                                             inHistory: true)
                            }
                            .foregroundColor(.primary)
                        }
                        // TODO:  If no meals, direct user to click the edit button at the top left to add Ideas
                    }
                }
                .padding()
            }
            .onAppear(perform: vm.fetchMeals)
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
        }
    }
}

struct MyIdeasView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasView()
    }
}
