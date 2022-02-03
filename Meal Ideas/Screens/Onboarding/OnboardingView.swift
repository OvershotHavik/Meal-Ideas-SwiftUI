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
    case createYourFirst = "Create your first Idea"
    case addCustom = "Add custom items"
    case searchForIdeas = "Searching for ideas"
    case adaptiveFilter = "Adaptive Filters"
    case additionalSources = "Additional Sources"
    case favoritesAndHistory = "Favorites and History"
}

enum OnboardingSecondary: String{
    case welcome = "To get started, tap the Edit button at the top left."
    case myIdeasList = "Here is where you can select a meal to edit \n\nor tap the + to create a new one."
    case createYourFirst = "Here you will be able to fill in the information for your meal. \n\nThe only thing that is required is the meal name. \n\nHowever the more you add the better the filters will work."
    case addCustom = "Not seeing a category, ingredient, or side you want? \n\nTap the + to add your own custom ones! \n\nThese can be edited in the Settings tab."
    case searchForIdeas = "Tap Surprise Me for a random meal \n\nOr search by keyword in the text field. \n\nOr tap the filter icon to get more options."
    case adaptiveFilter = "For My Ideas, the filters will only \nshow choices for meals that have been created that contains the ingredient or category."
    case additionalSources = "Not sure what to make? \n\nNeed some more inspiration? \n\nYou can search other sources. Whichever search type you select will cary over to the other sources automatically. "
    case favoritesAndHistory = "Each source keeps track of the meals you have viewed, along with favorited meals. \n\nThese can be viewed here."
    
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
                                   showsDismissButton: true)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.myIdeasList.rawValue,
                                   title: .myIdeasList,
                                   secondary: .myIdeasList,
                                   showsDismissButton: true)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.createAMealShort.rawValue,
                                   title: .createYourFirst,
                                   secondary: .createYourFirst,
                                   showsDismissButton: true)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.addCustomItemImage.rawValue,
                                   title: .addCustom,
                                   secondary: .addCustom,
                                   showsDismissButton: true)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.filterMenuImage.rawValue,
                                   title: .searchForIdeas,
                                   secondary: .searchForIdeas,
                                   showsDismissButton: true)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.adaptiveFilterImage.rawValue,
                                   title: .adaptiveFilter,
                                   secondary: .adaptiveFilter,
                                   showsDismissButton: true)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.tabBarImage.rawValue,
                                   title: .additionalSources,
                                   secondary: .additionalSources,
                                   showsDismissButton: true)
                
                OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                                   image: ImageNames.topViewFavoritesHighlighted.rawValue,
                                   title: .favoritesAndHistory,
                                   secondary: .favoritesAndHistory,
                                   showsDismissButton: true)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(shouldShowOnboarding: .constant(false))
    }
}
