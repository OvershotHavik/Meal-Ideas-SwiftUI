//
//  DVIngredientCell.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/3/22.
//

import SwiftUI

struct DetailViewIngredientCell: View {
    var ingredient: String
    var measurement: String
    var selected: Bool
    var body: some View {
        let modifiedMealDB = ingredient.replacingOccurrences(of: " ", with: "%20")
        if let mealDBImages = URL(string: "\(BaseURL.ingredientImage)\(modifiedMealDB).png"){
            ZStack(alignment: .leading){
//                Color.blue // only applies to the cell, not the list
                
                HStack{
                    LoadRemoteImageView(urlString: mealDBImages.absoluteString)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    VStack(alignment: .leading){
                        Text(ingredient)
                            .font(.body)
                            .padding(.horizontal)
                        Text(measurement)
                            .font(.body)
                            .padding(.horizontal)
                    }

                    Spacer()
                    if selected == true{
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}
/*
struct DVIngredientCell_Previews: PreviewProvider {
    static var previews: some View {
        DVIngredientCell()
    }
}
*/
