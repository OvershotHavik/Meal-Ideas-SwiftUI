//
//  IngredientView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct IngredientView: View {
    var name: String
    var value: String?
    var image: String // the url to the image eventually
    var body: some View {
        VStack{
            Image(image)
                .resizable()
                .clipped()
                .frame(height: 36)
                
            Text(value ?? "")
                .padding(.horizontal)
                .background(.red)
                .cornerRadius(.infinity)
            
            Text(name)
                .font(.body)
        }
        .frame(width: 170, height: 100, alignment: .center)
        .background(.blue)
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView(name: "Pizza", value: "1", image: "Pizza")
    }
}
