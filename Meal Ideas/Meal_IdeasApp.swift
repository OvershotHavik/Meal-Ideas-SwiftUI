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
    let userEnvironment = UserEnvironment()
    var body: some Scene {
        WindowGroup {
            MealIdeasTabView()
//            CustomFilterView(vm: CustomFilterVM(source: .myIdeas,
//                                                  plist: .categories,
//                                                  userIngredients: [],
//                                                  userCategories: []))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(query)
                .environmentObject(userEnvironment)
        }
    }
}
