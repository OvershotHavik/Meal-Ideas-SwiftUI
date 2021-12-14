//
//  MainTabView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MealIdeasTabView: View {
    @EnvironmentObject var query: Query
    
    var body: some View {
        TabView{
            MyIdeasView(vm: MyIdeasVM())
                .tabItem {
                    Label("My Ideas", systemImage: "person")
                }
            MealDBView(vm: MealDBVM())
                .tabItem {
                    Label("The Meal DB", systemImage: "fork.knife.circle.fill")
                }
            SpoonView(vm: SpoonVM())
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
