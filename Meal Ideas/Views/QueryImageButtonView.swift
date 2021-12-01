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
        Button {
            query.query = title
            
        } label: {
            Image(systemName: title.rawValue)
                .padding(.horizontal, 5)
                .border(Color.black, width: 2)
                .opacity((query.query.rawValue == title.rawValue) ? 1 : 0.5)
        }
    }
}

struct QueryImageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        QueryImageButtonView(title: .favorite)
    }
}
