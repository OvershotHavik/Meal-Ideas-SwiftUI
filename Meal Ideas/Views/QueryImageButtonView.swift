//
//  QueryImageButtonView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct QueryImageButtonView: View {
    @EnvironmentObject var query : Query
    var title: QueryType
    var body: some View {
        NavigationLink {
//            query.queryType = title
            FavoritesListView(vm: FavoritesListVM(), source: .mealDB)
        } label: {
            Image(systemName: title.rawValue)
                .padding(.horizontal, 5)
                .border(Color.black, width: 2)
                .opacity((query.queryType.rawValue == title.rawValue) ? 1 : 0.5)
        }

//        Button {
//            query.queryType = title
//
//        } label: {
//
//        }
    }
}

struct QueryImageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        QueryImageButtonView(title: .favorite)
    }
}
