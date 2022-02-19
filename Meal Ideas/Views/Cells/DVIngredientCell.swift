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
    @State var selected: Bool
    @State var image : UIImage?
    var mealName : String
    @EnvironmentObject var query: Query
    
    var body: some View {
        ZStack(alignment: .leading){
            HStack{
                Image(uiImage: image ?? UIImage(imageLiteralResourceName: "Placeholder"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .clipShape(Circle())
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
            .contentShape(Rectangle())
            .onTapGesture {
                print("ingredient: \(ingredient), measurement: \(measurement)")
                
                //                    var ingredientToShare = ""
                //                    if measurement == "" {
                //                        ingredientToShare = ingredient
                //                    } else {
                //                        ingredientToShare = "\(ingredient) - \(measurement)"
                //                    }
                //                    query.modifyIngredientsToShare(selectedIngredient: ingredientToShare)
                selected.toggle()
                if selected{
                    PersistenceController.shared.addToShoppingList(mealName: mealName,
                                                                   ingredient: ingredient,
                                                                   measurement: measurement,
                                                                   checkedOff: false) // checked off is used in shopping list, not a reflection of the selected status in this view
                } else {
                    PersistenceController.shared.removeFromShoppingList(mealName: mealName,
                                                                        ingredient: ingredient,
                                                                        measurement: measurement,
                                                                        checkedOff: false) // checked off is used in shopping list, not a reflection of the selected status in this view
                }
                //                    checkedOff = selected
            }
        }
        .onAppear{
            getImage(ingredientName: ingredient)
        }
        
    }
    func getImage(ingredientName: String){
        let modifiedMealDB = ingredientName.replacingOccurrences(of: " ", with: "%20")
        let mealDBImages = "\(BaseURL.ingredientImage)\(modifiedMealDB).png"
        NetworkManager.shared.downloadImage(fromURLString: mealDBImages) { uiImage in
            guard let uiImage = uiImage else { return }
            DispatchQueue.main.async {
                self.image = uiImage
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
