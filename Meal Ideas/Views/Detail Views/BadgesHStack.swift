//
//  BadgesHStack.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct BadgesHStack: View {
    var categories: [String]
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(categories, id: \.self) {cat in
                    Text(cat)
                        .background(.cyan)
                }
            }
        }
    }
}

struct BadgesHStack_Previews: PreviewProvider {
    static var previews: some View {
        BadgesHStack(categories: ["breakfast"])
    }
}
