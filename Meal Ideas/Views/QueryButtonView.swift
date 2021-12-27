//
//  QueryButtonView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct QueryButtonView: View {
    var title: QueryType
    @EnvironmentObject var query : Query

    var body: some View {
        Button {
            query.queryType = title
            query.selected = nil
        } label: {
            Text(title.rawValue)
                .padding(.horizontal)
                .border(Color.black, width: 2)
                .opacity((query.queryType.rawValue == title.rawValue) ? 1 : 0.5)
        }

    }
}

struct QueryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        QueryButtonView(title: .category)
    }
}
