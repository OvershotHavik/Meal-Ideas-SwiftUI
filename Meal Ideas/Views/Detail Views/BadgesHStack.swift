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
        ScrollView(.horizontal){
            HStack{
                Text(title)
                    .font(.body)
                ForEach(items, id: \.self) {cat in
                    Text(cat)
                        .padding(3)
                        .background(LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]),
                                                   startPoint: .top,
                                                   endPoint: .bottom))
                        .cornerRadius(10)
                }
                
            }
        }
    }
}




struct BadgesHStack_Previews: PreviewProvider {
    static var previews: some View {
        BadgesHStack(title: "Category", items: ["breakfast"], topColor: .blue, bottomColor: .green)
    }
}
