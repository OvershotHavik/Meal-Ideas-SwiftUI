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
                                   image: ImageNames.topViewEditHighlightImage.rawValue,
                                   title: .welcome,
                                   secondary: .welcome,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.myIdeasList.rawValue,
                                   title: .myIdeasList,
                                   secondary: .myIdeasList,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.createAMealImage.rawValue,
                                   title: .createYourFirst,
                                   secondary: .createYourFirst,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.addCustomItemImage.rawValue,
                                   title: .addCustom,
                                   secondary: .addCustom,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.filterMenuImage.rawValue,
                                   title: .searchForIdeas,
                                   secondary: .searchForIdeas,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.adaptiveFilterImage.rawValue,
                                   title: .adaptiveFilter,
                                   secondary: .adaptiveFilter,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.tabBarImage.rawValue,
                                   title: .additionalSources,
                                   secondary: .additionalSources,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.topViewFavoritesHighlighted.rawValue,
                                   title: .favoritesAndHistory,
                                   secondary: .favoritesAndHistory,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                   image: ImageNames.SLAdd.rawValue,
                                   title: .shoppingList,
                                   secondary: .shoppingList,
                                   showsDismissButton: false)
                
                OnboardingPageViewSystemName(shouldShowOnboarding: $shouldShowInitialOnboarding,
                                             image: "person.icloud.fill",
                                             title: .cloudKitEnabled,
                                             secondary: .cloudKitEnabled,
                                             showsDismissButton: true)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
