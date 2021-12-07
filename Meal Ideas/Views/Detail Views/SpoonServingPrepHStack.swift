//
//  SpoonBadgesHStack.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct SpoonServingPrepHStack: View {
    var prepTime: Int?
    var servings: Int?
    
    var body: some View {
        HStack{
            //if either are nil, hide the icon as well
            if let safePrepTime = prepTime{
                Image(systemName: "timer")
                Text("\(safePrepTime) min")
                // TODO:  depending how this comes through may want to convert it to hours: minutes
            }

            if let safeServings = servings{
                Image(systemName: "person.fill")
                Text("\(safeServings)")
            }
        }
    }
}

struct SpoonBadgesHStack_Previews: PreviewProvider {
    static var previews: some View {
        SpoonServingPrepHStack(prepTime: 20, servings: 2)
    }
}
