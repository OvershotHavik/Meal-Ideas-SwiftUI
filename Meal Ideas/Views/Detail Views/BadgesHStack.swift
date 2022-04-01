//
//  BadgesHStack.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct BadgesHStack: View {
    var title: String
    var items: [String]
    var topColor: Color
    var bottomColor: Color
    
    
    var body: some View {
        HStack{
            Text(title)
                .font(.body)
            ScrollView(.horizontal){
                HStack{
                    ForEach(items.sorted(by: {$0 < $1}), id: \.self) {cat in
                        Text(cat)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]),
                                                       startPoint: .top,
                                                       endPoint: .bottom))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
