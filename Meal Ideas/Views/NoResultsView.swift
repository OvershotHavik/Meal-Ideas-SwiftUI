//
//  NoResultsView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/12/21.
//

import SwiftUI

struct NoResultsView: View {
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
//            .offset(y: -50)
        }
    }
}

struct NoResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NoResultsView(imageName: "Placeholder", message: "no meals found")
    }
}
