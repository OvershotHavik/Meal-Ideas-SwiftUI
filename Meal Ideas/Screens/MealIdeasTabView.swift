//
//  MainTabView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MealIdeasTabView: View {
    var body: some View {
        TabView{
            MyIdeasView()
                .tabItem {
                    Label("My Ideas", systemImage: "person")
                }
            MealDBView()
                .tabItem {
                    Label("The Meal DB", systemImage: "fork.knife.circle.fill")
                }
            SpoonView()
                .tabItem {
                    Label("Spoonacular", systemImage: "fork.knife.circle.fill")
                }
        }
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MealIdeasTabView()
    }
}
