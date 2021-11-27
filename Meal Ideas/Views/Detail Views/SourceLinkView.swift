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
        
        if let safeURL = source{
            if safeURL == ""{
                //do something
            } else {
                Link(destination: URL(string: safeURL)!) {
                    Text("Visit Source")
                }
            }

        }
        //if source is nil then don't show the source button
    }
}

struct SourceLinkView_Previews: PreviewProvider {
    static var previews: some View {
        SourceLinkView()
    }
}
