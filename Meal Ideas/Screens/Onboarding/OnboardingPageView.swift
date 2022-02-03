//
//  OnboardingPageView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/3/22.
//

import SwiftUI

struct OnboardingPageView: View{
    @Binding var shouldShowOnboarding: Bool
    var image: String
    var primaryText: String
    var secondaryText: String
    var showsDismissButton: Bool
    var body: some View{
        VStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding()
            Text(primaryText)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(secondaryText)
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            if showsDismissButton{
                Button {
                    shouldShowOnboarding.toggle()
                    print("shouldShowOnboarding: \(shouldShowOnboarding)")
                } label: {
                    Text("Get Started")
                        .bold()
                        .foregroundColor(.primary)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .cornerRadius(6)
                }

            }
        }
    }
}
