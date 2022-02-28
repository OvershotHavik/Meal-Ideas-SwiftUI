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
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.SLIcon.rawValue,
                                   title: .shoppingList,
                                   secondary: .shoppingListIntro,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.SLAdd.rawValue,
                                   title: .onceAdded,
                                   secondary: .onceAdded,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.SLSeparation.rawValue,
                                   title: .mealSeparation,
                                   secondary: .mealSeparation,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.SLSearchable.rawValue,
                                   title: .searchable,
                                   secondary: .searchable,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.SLRemove.rawValue,
                                   title: .clearingList,
                                   secondary: .clearingList,
                                   showsDismissButton: false)
                
                OnboardingPageViewSystemName(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: "person.icloud.fill",
                                   title: .cloudKitEnabled,
                                   secondary: .shoppingCloudKitEnabled,
                                   showsDismissButton: true)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
