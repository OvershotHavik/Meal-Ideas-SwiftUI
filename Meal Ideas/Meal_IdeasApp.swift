//
//  Meal_IdeasApp.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

@main
struct Meal_IdeasApp: App {
    let persistenceController = PersistenceController.shared
    let query = Query()
    var body: some Scene {
        WindowGroup {
//            IngredientsListView(vm: IngredientsListVM())
//            EditIdeaView(vm: EditIdeaVM(meal: TestMeal.testUserMeal))
//            TestCoreDataView()
            
            MealIdeasTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(query)
            
        }
    }
}
