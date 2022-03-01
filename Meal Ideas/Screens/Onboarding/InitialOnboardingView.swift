//
//  SwiftUIView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/2/22.
//

import SwiftUI

struct InitialOnboardingView: View {
    @Binding var shouldShowInitialOnboarding: Bool
    
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            TabView{
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .topViewEditHighlightImage,
                                   title: .welcome,
                                   secondary: .welcome,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .myIdeasList,
                                   title: .myIdeasList,
                                   secondary: .myIdeasList,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .createAMealImage,
                                   title: .createYourFirst,
                                   secondary: .createYourFirst,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .addCustomItemImage,
                                   title: .addCustom,
                                   secondary: .addCustom,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .filterMenuImage,
                                   title: .searchForIdeas,
                                   secondary: .searchForIdeas,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .adaptiveFilterImage,
                                   title: .adaptiveFilter,
                                   secondary: .adaptiveFilter,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .tabBarImage,
                                   title: .additionalSources,
                                   secondary: .additionalSources,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .topViewFavoritesHighlighted,
                                   title: .favoritesAndHistory,
                                   secondary: .favoritesAndHistory,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: .SLAdd,
                                   title: .shoppingList,
                                   secondary: .shoppingList,
                                   showsDismissButton: false)
                
                OnboardingPageViewSystemName(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                             image: .iCloud,
                                             title: .cloudKitEnabled,
                                             secondary: .cloudKitEnabled,
                                             showsDismissButton: true)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
