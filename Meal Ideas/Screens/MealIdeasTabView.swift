//
//  MainTabView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MealIdeasTabView: View {
    @AppStorage("shouldShowInitialOnboarding") var shouldShowInitialOnboarding: Bool = true
    @EnvironmentObject var query: Query
    @EnvironmentObject var userEnvironment: UserEnvironment
    @EnvironmentObject var shopping: Shopping
    
    var body: some View {
        TabView{
            MyIdeasView(vm: MyIdeasVM())
                .tabItem {
                    Label(Titles.myIdeas.rawValue, systemImage: SFSymbols.person.rawValue)
                }
            MealDBView(vm: MealDBVM())
                .tabItem {
                    Label(Titles.mealDB.rawValue, systemImage: SFSymbols.source.rawValue)
                }
            SpoonView(vm: SpoonVM(sourceCategory: .spoonCategories, source: .spoonacular))
                .tabItem {
                    Label(Titles.spoonacular.rawValue, systemImage: SFSymbols.source.rawValue)
                }
            ShoppingListView(vm: ShoppingListVM())
                .tabItem {
                    Label(Titles.shoppingList.rawValue, systemImage: SFSymbols.list.rawValue)
                }
            SettingsView(vm: SettingsVM())
                .tabItem {
                    Label(Titles.settings.rawValue, systemImage: SFSymbols.settings.rawValue)
                }
        }
        .fullScreenCover(isPresented: $shouldShowInitialOnboarding, content: {
            InitialOnboardingView(shouldShowInitialOnboarding: $shouldShowInitialOnboarding)
        })
        .onAppear{
            query.getFavorites()
            query.getHistory()
            userEnvironment.retrieveUserSettings()
            shopping.getShoppingList()
        }
    }
}

