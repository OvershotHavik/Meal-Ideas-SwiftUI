//
//  NoResultsView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/12/21.
//

import SwiftUI

struct NoResultsViewWithImage: View {
    let imageName : String
    let message: String
    var body: some View {
        ZStack{
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack{
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .padding()
                Text(message)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}

struct NoResultsView: View {
    let message: String
    var body: some View{
        VStack{
            Spacer()
            Text(message)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.red)
    }
}
struct NoResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NoResultsViewWithImage(imageName: UI.placeholderMeal, message: "no meals found")
    }
}
