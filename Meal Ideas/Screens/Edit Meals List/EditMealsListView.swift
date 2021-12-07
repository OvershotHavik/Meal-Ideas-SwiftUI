//
//  EditMealsListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI

struct EditMealsListView: View {
    @StateObject var vm = EditMealsListVM()
    var body: some View {
        VStack(spacing: 20) {
            List {
                ForEach(vm.savedMeals) {meal in
                    NavigationLink(destination: EditIdeaView(vm: EditIdeaVM(meal: meal))) {
                        Text(meal.mealName ?? "No name")
                            .onTapGesture {
                            }
                    }
                }
                // TODO:  If no meals, show a view to advise them to click the + to create a new meal
                .onDelete { IndexSet in
                    PersistenceController.shared.deleteMealInList(indexSet: IndexSet)
                    vm.fetchMeals()
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Edit Your Ideas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditIdeaView(vm: EditIdeaVM(meal: nil))) {
                    Image(systemName: "plus")
                        .padding(.horizontal)
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear(perform: vm.fetchMeals)
    }
}

struct TestCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        EditMealsListView(vm: EditMealsListVM())
    }
}
