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
                Text(minutesToHoursAndMinutes(minutes: safePrepTime))
            }

            if let safeServings = servings{
                Image(systemName: "person.fill")
                Text("\(safeServings)")
            }
        }
    }
    
    func minutesToHoursAndMinutes (minutes : Int) -> String{
        let hours = minutes / 60
        let leftoverMinutes = minutes % 60
        
        if hours != 0{
            return   "\(hours)h \(leftoverMinutes)m"
        } else {
            return  "\(leftoverMinutes) min"
        }
    }
}

struct SpoonBadgesHStack_Previews: PreviewProvider {
    static var previews: some View {
        SpoonServingPrepHStack(prepTime: 20, servings: 2)
    }
}
