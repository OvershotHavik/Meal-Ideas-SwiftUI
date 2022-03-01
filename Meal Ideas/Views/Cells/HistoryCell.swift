//
//  HistoryCell.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/20/21.
//

import SwiftUI

struct HistoryCell: View {
    var mealName: String
    var timeStamp: Date?
    var favorited: Bool
    
    
    var body: some View {
        HStack{
            if let safeDate = timeStamp{
                Text(convertDate(date: safeDate))
            }
            Text(mealName)
            Spacer()
            if favorited == true {
                Image(systemName: SFSymbols.favorited.rawValue)
                    .foregroundColor(.pink)
            }
        }
        .contentShape(Rectangle())
    }


    func convertDate(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        let time = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "E, MMM d"
        let day = dateFormatter.string(from: date)
        return "\(time)\n\(day)"
    }
}
