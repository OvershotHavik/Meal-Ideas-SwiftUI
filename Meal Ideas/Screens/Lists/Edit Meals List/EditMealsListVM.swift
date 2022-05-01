//
//  EditMealsListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI
import CoreData

final class EditMealsListVM: ObservableObject{
    @Published var savedMeals: [UserMeals] = []
    @Published var showingDeleteAlert = false
    @Published var selectedIndexSet: IndexSet?
    private let pc = PersistenceController.shared
    @Published var searchText = ""
    var searchResults: [UserMeals] {
        if searchText.isEmpty {
            return savedMeals
        } else {
            return savedMeals.filter { $0.mealName!.containsIgnoringCase(find: searchText) }
        }
    }
    
    init() {
        fetchMeals()
    }
    

    func fetchMeals(){
        let request = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
        do {
            savedMeals = try pc.container.viewContext.fetch(request)
            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    

    func deleteMeal(){
        if let safeIndexSet = selectedIndexSet{
            withAnimation {
                PersistenceController.shared.deleteInList(indexSet: safeIndexSet,
                                                          entityName: .userMeals,
                                                          source: .myIdeas)
                fetchMeals()
            }
        }
    }
}
