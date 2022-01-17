//
//  AllResultsShown.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/13/22.
//

import SwiftUI

struct AllResultsShownText: View {
    var body: some View {
        Text("All results shown for this search")
            .foregroundColor(.gray)
            .opacity(0.5)
    }
}

struct AllResultsShown_Previews: PreviewProvider {
    static var previews: some View {
        AllResultsShownText()
    }
}
