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
    let url = URL(string: "https://www.google.com/search?client=safari&sxsrf=AOaemvIzNb62INPmM4RP8xwxYhVS3bhpyQ:1642621256576&q=covid+vaccine+near+me&oi=ddle&ct=214458547&hl=en&sa=X&ved=0ahUKEwjbifuDyb71AhVMq3IEHU53BdAQPQgE")
    var body: some Scene {
        WindowGroup {
//            IngredientsListView(vm: IngredientsListVM())
//            EditIdeaView(vm: EditIdeaVM(meal: nil))

//            SingleChoiceListView(vm: SingleChoiceListVM(PList: .sides))
            MealIdeasTabView()
//            AsyncRemoteImageView(source: url!)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(query)
            
        }
    }
}
