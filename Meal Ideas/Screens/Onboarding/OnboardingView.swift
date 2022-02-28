//
//  SwiftUIView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/2/22.
//

import SwiftUI

enum OnboardingTitles: String{
    case welcome = "Welcome to Meal Ideas!"
    case myIdeasList = "Your Ideas"
    case createYourFirst = "Create Your Meal Idea"
    case addCustom = "Add Custom Items"
    case searchForIdeas = "Searching for Ideas"
    case adaptiveFilter = "Adaptive Filters"
    case additionalSources = "Additional Sources"
    case favoritesAndHistory = "Favorites and History"
    case cloudKitEnabled = "Sync Across Devices"
}


enum OnboardingSecondary: String{
    case welcome = "To get to your meals, use the Edit button at the top left."
    case myIdeasList = "Here is where you can select a meal to edit. \n\nTap the + to create a new meal."
    case createYourFirst = "Here you will be able to fill in the information for your meal. \n\nThe only thing that is required is the meal name. \n\nHowever, the more you add the better the filters will work."
    case addCustom = "Not seeing a category, ingredient, or side you want? \n\nTap the + to add your own custom ones! \n\nThese can be edited in the Settings tab."
    case searchForIdeas = "Tap Surprise Me for a random meal. \n\nOr search by keyword in the text field. \n\nOr tap the filter icon to get more options."
    case adaptiveFilter = "For My Ideas only: \nThe filters will only show choices for ingredients or categories for meals that have been created with them. \n\nThe other sources only list categories that are supported by them."
    case additionalSources = "Not sure what to make? \n\nNeed some more inspiration? \n\nYou can search other sources! \n\nWhichever search type you select will cary over to the other sources automatically."
    case favoritesAndHistory = "Each source keeps track of the meals you have viewed, along with favorited meals. \n\nThese can be viewed here."
    case cloudKitEnabled = "Any meals you create, custom items, shopping list, favorites and history for each source is synced across all your iOS devices."
}




struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            TabView{
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.topViewEditHighlightImage.rawValue,
                                   title: .welcome,
                                   secondary: .welcome,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.myIdeasList.rawValue,
                                   title: .myIdeasList,
                                   secondary: .myIdeasList,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.createAMealImage.rawValue,
                                   title: .createYourFirst,
                                   secondary: .createYourFirst,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.addCustomItemImage.rawValue,
                                   title: .addCustom,
                                   secondary: .addCustom,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.filterMenuImage.rawValue,
                                   title: .searchForIdeas,
                                   secondary: .searchForIdeas,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.adaptiveFilterImage.rawValue,
                                   title: .adaptiveFilter,
                                   secondary: .adaptiveFilter,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.tabBarImage.rawValue,
                                   title: .additionalSources,
                                   secondary: .additionalSources,
                                   showsDismissButton: false)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.topViewFavoritesHighlighted.rawValue,
                                   title: .favoritesAndHistory,
                                   secondary: .favoritesAndHistory,
                                   showsDismissButton: false)
                
                OnboardingPageViewSystemName(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: "person.icloud.fill",
                                   title: .cloudKitEnabled,
                                   secondary: .cloudKitEnabled,
                                   showsDismissButton: true)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
