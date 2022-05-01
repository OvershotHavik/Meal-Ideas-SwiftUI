//
//  OnboardingPageViewSystemName.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/20/22.
//

import SwiftUI

struct OnboardingPageViewSystemName: View{
    @Binding var shouldShowOnboarding: Bool
    var image: SFSymbols
    var title: OnboardingTitles
    var secondary: OnboardingSecondary
    var showsDismissButton: Bool
    
    var body: some View{
        GeometryReader{ screenBounds in
            ScrollView{
                VStack(spacing: 10) {
                    Image(systemName: image.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenBounds.size.width/2, height: screenBounds.size.height/3)
                    Text(title.rawValue)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(secondary.rawValue)
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                    if showsDismissButton{
                        Button {
                            shouldShowOnboarding.toggle()
                            print("shouldShowOnboarding: \(shouldShowOnboarding)")
                        } label: {
                            Text("Get Started")
                                .bold()
                                .modifier(MIButtonModifier())
                        }
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 20)
                        Spacer()
                    }else {
                        VStack{
                            HStack(spacing: 10){
                                Text("Swipe to Continue")
                                Image(systemName: SFSymbols.chevronRight.rawValue)
                            }
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 20)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
