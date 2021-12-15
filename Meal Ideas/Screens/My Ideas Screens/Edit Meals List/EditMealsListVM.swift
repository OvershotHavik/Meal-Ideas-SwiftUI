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
    @Published var TextFieldText: String = ""
    @Published var showingDeleteAlert = false
    @Published var selectedIndexSet: IndexSet?
    private let pc = UserMealsPC.shared
    init() {
        fetchMeals()
    }
    
    
    func fetchMeals(){
        let request = NSFetchRequest<UserMeals>(entityName: "UserMeals")
        do {
            savedMeals = try pc.container.viewContext.fetch(request)
            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
}
