//
//  UserPrepHStack.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/31/21.
//

import SwiftUI

struct UserPrepHStack: View {
    var hour: Int16?
    var minute: Int16?
    var second: Int16?
    var body: some View {
        HStack{
            if hour != 0 || minute != 0 || second != 0{
                Image(systemName: "timer")
            }
            
            if let safeHour = hour{
                if safeHour != 0{
                    Text("\(safeHour)h")
                }
            }
            if let safeMinute = minute{
                if safeMinute != 0 {
                    Text("\(safeMinute)m")
                }
            }
            if let safeSecond = second{
                if safeSecond != 0{
                    Text("\(safeSecond)s")
                }
            }
        }
    }
}

struct UserPrepHStack_Previews: PreviewProvider {
    static var previews: some View {
        UserPrepHStack()
    }
}
