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
        List {
            if vm.savedMeals.isEmpty{
                NoResultsView(message: Messages.tapToCreate.rawValue)
            }
            ForEach(vm.searchResults.sorted{$0.mealName ?? "" < $1.mealName ?? ""}) {meal in
                NavigationLink(destination: EditIdeaView(vm: EditIdeaVM(meal: meal))) {
                    Text(meal.mealName ?? "No name")
                }
            }
            .onDelete { IndexSet in
                vm.showingDeleteAlert.toggle()
                vm.selectedIndexSet = IndexSet
            }
        }
        .searchable(text: $vm.searchText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text(Titles.myIdeas.rawValue)
            })
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditIdeaView(vm: EditIdeaVM(meal: nil))) {
                    Image(systemName: SFSymbols.plus.rawValue)
                        .padding(.horizontal)
                        .foregroundColor(.primary)
                }
            }
        }
        .onAppear{
            vm.fetchMeals()
        }
        // Delete Alert
        .alert("Delete Meal", isPresented: $vm.showingDeleteAlert) {
            Button("Delete", role: .destructive, action: vm.deleteMeal)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete the meal?")
        }
    }
}
