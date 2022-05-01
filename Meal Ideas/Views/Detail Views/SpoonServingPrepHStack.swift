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
                Image(systemName: SFSymbols.timer.rawValue)
                Text(minutesToHoursAndMinutes(minutes: safePrepTime))
            }
            if let safeServings = servings{
                Image(systemName: SFSymbols.personFilled.rawValue)
                Text("\(safeServings)")
            }
        }
    }
    
    
    private func minutesToHoursAndMinutes (minutes : Int) -> String{
        let hours = minutes / 60
        let leftoverMinutes = minutes % 60
        
        if hours != 0{
            return   "\(hours)h \(leftoverMinutes)m"
        } else {
            return  "\(leftoverMinutes) min"
        }
    }
}
