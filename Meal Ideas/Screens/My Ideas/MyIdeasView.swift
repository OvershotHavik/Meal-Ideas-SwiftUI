//
//  MyIdeasView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MyIdeasView: View {
    var body: some View {
        VStack{
            Text("Welcome to My Ideas View")
            Text(APIKey.test)
            Text("Test 2")
        }
        
        
    }
}

struct MyIdeasView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasView()
    }
}
