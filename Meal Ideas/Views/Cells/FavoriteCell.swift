//
//  FavoriteCell.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/19/21.
//

import SwiftUI

struct FavoriteCell: View {
    var mealName: String?
    var body: some View {
        HStack{
            Text(mealName ?? "")
            Spacer()
            Image(systemName: SFSymbols.favorited.rawValue)
                .foregroundColor(.pink)
        }
        .contentShape(Rectangle())
    }
}
