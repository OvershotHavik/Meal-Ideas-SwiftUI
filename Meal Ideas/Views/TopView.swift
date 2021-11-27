//
//  TopView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct TopView: View {
    @State var search = ""
    var body: some View {
        VStack{
            Text("Selected...")
            TextField("Keyword Search....", text: $search)
                .frame(width: 200)
//                .background(.white)
                .textFieldStyle(.roundedBorder)
            Divider()
            Spacer()
            
            TopViewButtons()
        }
        .background(Color.blue)
        .frame(height: 75)
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}

struct TopViewButtons: View{
    var body: some View{
        //When button is pressed, transition the top view to show the options available for the respective choice
        HStack{
            Button("Random"){}
            .border(Color.black, width: 2)
            Button("Category"){}
            .border(Color.black, width: 2)
            Button("Ingredient"){}
            .border(Color.black, width: 2)
            
            Button {
                
            } label: {
                Image(systemName: "book")
                    .padding(.horizontal)
                    .border(Color.black, width: 2)
            }
            Button {
                
            } label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                    .padding(.horizontal)
                    .border(Color.black, width: 2)
            }

        }
        .padding(.bottom, 5)
        .foregroundColor(.primary)
    }
}
