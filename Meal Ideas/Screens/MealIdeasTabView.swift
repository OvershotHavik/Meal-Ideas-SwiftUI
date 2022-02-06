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
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MealIdeasTabView()
    }
}
