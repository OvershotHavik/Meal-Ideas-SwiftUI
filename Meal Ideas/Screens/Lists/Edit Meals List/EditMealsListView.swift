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
                if vm.savedMeals.isEmpty{
                    NoResultsView(message: "Tap the + to create a meal")
                }
                ForEach(vm.searchResults) {meal in
                    NavigationLink(destination: EditIdeaView(vm: EditIdeaVM(meal: meal))) {
                        Text(meal.mealName ?? "No name")
                    }
                }
                .onDelete { IndexSet in
                    vm.showingDeleteAlert.toggle()
                    vm.selectedIndexSet = IndexSet
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $vm.searchText)
        }
        
        .navigationTitle("Edit Your Ideas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditIdeaView(vm: EditIdeaVM(meal: nil))) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear(perform: vm.fetchMeals)
        // MARK: - Delete Alert
        .alert("Delete Meal", isPresented: $vm.showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteMeal)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete the meal?")
        }
    }
    
    func deleteMeal(){
        if let safeIndexSet = vm.selectedIndexSet{
            withAnimation {
                PersistenceController.shared.deleteInList(indexSet: safeIndexSet,
                                                          entityName: .userMeals)
                vm.fetchMeals()
            }
        }
    }
    
}

struct TestCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        EditMealsListView(vm: EditMealsListVM())
    }
}
