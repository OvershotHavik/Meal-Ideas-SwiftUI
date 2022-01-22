//
//  IngredientCell.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct IngredientCell: View {
    var ingredient: Ingredients.Meals
    var selected: Bool
    @State private var image: UIImage?
    @Environment(\.asyncImageLoader) private var asyncImageLoader

    var body: some View {
        let modifiedMealDB = ingredient.strIngredient.replacingOccurrences(of: " ", with: "%20")
        if let mealDBImages = URL(string: "\(BaseURL.ingredientImage)\(modifiedMealDB).png"){
            ZStack(alignment: .leading){
//                Color.blue // only applies to the cell, not the list
                
                HStack{
                    LoadRemoteImageView(urlString: mealDBImages.absoluteString)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    Text(ingredient.strIngredient)
                        .font(.body)
                        .padding(.horizontal)
                    Spacer()
                    if selected == true{
                        Image(systemName: "checkmark")
                    }
                }
            }
            .background(Color(uiColor: .secondarySystemBackground))
        }
    }
}
/*
struct IngredientCell_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCell(ingredient: Ingredients.Meals)
    }
}
*/


// TODO:  Keep for later integration with async image loader once developer added


/*
 struct IngredientCell: View {
     var ingredient: Ingredients.Meals
     var selected: Bool
     @State private var image: UIImage?
     @Environment(\.asyncImageLoader) private var asyncImageLoader

     var body: some View {
         let modifiedMealDB = ingredient.strIngredient.replacingOccurrences(of: " ", with: "%20")
         if let mealDBImages = URL(string: "\(BaseURL.ingredientImage)\(modifiedMealDB).png"){
             ZStack(alignment: .leading){
 //                Color.blue // only applies to the cell, not the list
                 
                 HStack{
                     if let image = image {
                         Image(uiImage: image)
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 50)
                     } else {
                         UI.placeholderImage
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 50)
                     }
                     
 //                    LoadRemoteImageView(urlString: mealDBImages.absoluteString)

                     Text(ingredient.strIngredient)
                         .font(.body)
                         .padding(.horizontal)
                     Spacer()
                     if selected == true{
                         Image(systemName: "checkmark")
                     }
                 }
             }
             .task{
                 await loadImage(at: mealDBImages)
             }
         }
     }
     
     func loadImage(at source: URL) async {
         do {
             image = try await asyncImageLoader.fetch(source)
         } catch {
             print(error)
         }
     }
 }
 */
