//
//  MainTabView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MealIdeasTabView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    
    @EnvironmentObject var query: Query
    @EnvironmentObject var userEnvironment: UserEnvironment
    @EnvironmentObject var shopping: Shopping
    var body: some View {
        TabView{
            MyIdeasView(vm: MyIdeasVM())
                .tabItem {
                    Label("My Ideas", systemImage: "person")
                }
            MealDBView(vm: MealDBVM(sourceCategory: .mealDBCategories))
                .tabItem {
                    Label("The MealDB", systemImage: "fork.knife.circle.fill")
                }
            SpoonView(vm: SpoonVM(sourceCategory: .spoonCategories))
                .tabItem {
                    Label("Spoonacular", systemImage: "fork.knife.circle.fill")
                }
            ShoppingListView(vm: ShoppingListVM())
                .tabItem {
                    Label("Shopping List", systemImage: "list.dash")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
        .onAppear{
            query.getFavorites()
            query.getHistory()
            userEnvironment.retrieveUserSettings()
            shopping.getShoppingList()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MealIdeasTabView()
    }
}
