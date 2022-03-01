//
//  ShoppingListOnboardingView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/28/22.
//

import SwiftUI

struct ShoppingListOnboardingView: View{
    @Binding var shouldShowShoppingListOnboarding: Bool
    
    var body: some View{
        ZStack{
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            TabView{
                OnboardingPageViewSystemName(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                             image: .list,
                                             title: .shoppingList,
                                             secondary: .shoppingListIntro,
                                             showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: .SLAdd,
                                   title: .onceAdded,
                                   secondary: .onceAdded,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: .SLSeparation,
                                   title: .mealSeparation,
                                   secondary: .mealSeparation,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: .SLSearchable,
                                   title: .searchable,
                                   secondary: .searchable,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: .SLRemove,
                                   title: .clearingList,
                                   secondary: .clearingList,
                                   showsDismissButton: false)
                
                OnboardingPageViewSystemName(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                             image: .iCloud,
                                             title: .cloudKitEnabled,
                                             secondary: .shoppingCloudKitEnabled,
                                             showsDismissButton: true)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
