//
//  SwiftUIView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/2/22.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        TabView{
            OnboardingPageView(shouldShowOnboarding: $shouldShowOnboarding,
                     image: "bell",
                     primaryText: "Push Notifcations",
                     secondaryText: "Enable these to stay up to doate with our app",
                     showsDismissButton: true)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(shouldShowOnboarding: .constant(false))
    }
}
