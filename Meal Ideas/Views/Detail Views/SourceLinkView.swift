//
//  SourceLinkView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct SourceLinkView: View {
    var source: String?
    var body: some View {
        Link(destination: URL(string: source ?? "https://www.google.com")!) {
            Text("Visit Source")
        }
    }
}

struct SourceLinkView_Previews: PreviewProvider {
    static var previews: some View {
        SourceLinkView()
    }
}
