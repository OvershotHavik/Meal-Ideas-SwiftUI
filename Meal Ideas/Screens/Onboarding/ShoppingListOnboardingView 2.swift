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
                                   image: ImageNames.topViewEditHighlightImage.rawValue,
                                   title: .shoppingListIntro,
                                   secondary: .shoppingListIntro,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.topViewEditHighlightImage.rawValue,
                                   title: .onceAdded,
                                   secondary: .onceAdded,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.topViewEditHighlightImage.rawValue,
                                   title: .mealSeparation,
                                   secondary: .mealSeparation,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.topViewEditHighlightImage.rawValue,
                                   title: .searchable,
                                   secondary: .searchable,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowShoppingListOnboarding,
                                   image: ImageNames.topViewEditHighlightImage.rawValue,
                                   title: .clearingList,
                                   secondary: .clearingList,
                                   showsDismissButton: true)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
