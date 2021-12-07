//
//  SourceLinkView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct LinkView: View {
    var url: String?
    var title: String
    var body: some View {
        
        if let safeURL = url{
            if safeURL == ""{
                //don't show a button
            } else {
                Link(destination: URL(string: safeURL)!) {
                    Text(title)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding(.bottom)
                }
            }
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView(url: "www.google.com", title: "Visit Google")
    }
}
