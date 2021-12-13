//
//  SpoonView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct SpoonView: View {
    @StateObject var vm : SpoonVM
    @EnvironmentObject var query: Query

    
    var body: some View {
        NavigationView{
            VStack{
                TopView(keywordSearchTapped: $vm.keywordSearchTapped)
                let columns = [GridItem(), GridItem()]
                ScrollView{
                    if vm.isLoading{
                        loadingView()
                    }
                    if vm.meals.isEmpty && vm.keywordResults.isEmpty && vm.isLoading == false{
                        NoResultsView(imageName: "Placeholder",
                                      message: "No meals found for your search")
                    }
                    if vm.keywordResults.isEmpty{
                        //Normal run through
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(vm.meals) { meal in
                                NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: meal, mealID: nil))) {
                                    MealCardView(mealPhoto: meal.image ?? "",
                                                 mealName: meal.title,
                                                 favorited: true,
                                                 inHistory: true)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    } else {
                        //Keyword search, need to fetch the meal on the VM
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(vm.keywordResults) { meal in
                                NavigationLink(destination: SpoonDetailView(vm: SpoonDetailVM(meal: nil, mealID: meal.id))) {
                                    MealCardView(mealPhoto: meal.image ?? "",
                                                 mealName: meal.title,
                                                 favorited: true,
                                                 inHistory: true)
                                }
                                .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
            .onAppear {
                if query.queryType != .keyword{
                    vm.checkQuery(query: query.selected ?? "", queryType: query.queryType)
                }
            }
            .alert(item: $vm.alertItem) { alertItem in
                Alert(title: alertItem.title,
                             message: alertItem.message,
                      dismissButton: .default(Text("OK"), action: stopLoading))
            }
            .onChange(of: vm.keywordSearchTapped, perform: { newValue in
                print("Keyword: \(query.keyword)")
                vm.checkQuery(query: query.keyword, queryType: .keyword)
            })
        }

    }
    func stopLoading(){
        vm.isLoading = false
    }
}

struct SpoonView_Previews: PreviewProvider {
    static var previews: some View {
        SpoonView(vm: SpoonVM())
    }
}
