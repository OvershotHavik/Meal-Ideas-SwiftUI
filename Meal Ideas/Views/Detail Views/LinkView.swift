//
//  SourceLinkView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct LinkView: View {
    var url: String?
    var title: String
    
    var body: some View {
        if let safeURL = url{
            if safeURL != ""{
                Link(destination: URL(string: safeURL)!) {
                    Text(title)
                        .modifier(MIButtonModifier())
                }
            }
        }
    }
}
