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
    var image: String // will need to be changed to the core data image eventually
    var body: some View {
        let modifiedMealDB = name.replacingOccurrences(of: " ", with: "%20")
        if let mealDBImages = URL(string: "\(BaseURL.ingredientImage)\(modifiedMealDB).png"){
            VStack{
                LoadRemoteImageView(urlString: mealDBImages.absoluteString )
                    .clipped()
                    .aspectRatio( contentMode: .fit)
                    .frame(height: 100)
                    
                Text(value ?? "")
                    .padding(.horizontal)
                    .background(.red)
                    .cornerRadius(.infinity)
                
                Text(name)
                    .font(.body)
            }
            .frame(width: 170, height: 150, alignment: .center)
            .background(.blue)
        }

    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView(name: "Pizza", value: "1", image: "Pizza")
    }
}



/*
if let safeIngredient = ingredient{
    let modifiedMealDB = safeIngredient.replacingOccurrences(of: " ", with: "%20")
    if let mealDBImages = URL(string: "https://www.themealdb.com/images/ingredients/\(modifiedMealDB).png"){
        DispatchQueue.main.async {
            ingredientCell.ivIngredientImage.loadImage(from: mealDBImages){
                
                    DispatchQueue.main.async {
                        if ingredientCell.ivIngredientImage.image == nil{
                        let modifiedSpoon = safeIngredient.replacingOccurrences(of: " ", with: "-")
                        if let SpoonImages = URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(String(describing: modifiedSpoon)).jpg") {
                            ingredientCell.ivIngredientImage.loadImage(from: SpoonImages){
                                print("Still no image after both for: \(safeIngredient)")
                            }
                        }
                    }
                }
            }
        }
    }
}
*/
