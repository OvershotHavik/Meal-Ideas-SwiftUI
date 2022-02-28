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
    var inShoppingList = false
    @EnvironmentObject var query: Query
    @EnvironmentObject var shopping: Shopping
    @State var alpha: Double = 1
    
    
    var body: some View {
        ZStack(alignment: .leading){
            HStack{
                Image(uiImage: image ?? UIImage(imageLiteralResourceName: "Placeholder"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .clipShape(Circle())
                    .opacity(alpha)

                VStack(alignment: .leading){
                    Text(ingredient)
                        .font(.body)
                        .padding(.horizontal)
                    Text(measurement)
                        .font(.body)
                        .padding(.horizontal)
                }
                .opacity(alpha)

                Spacer()
                if selected{
                    withAnimation(.easeIn(duration: 0.25).delay(0.25)){
                    Image(systemName: "checkmark")
                        .padding(.horizontal)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                print("ingredient: \(ingredient), measurement: \(measurement)")
                selected.toggle()
                withAnimation(.easeIn(duration: 0.25)){
                    alpha = 0
                }
                withAnimation(.easeIn(duration: 0.25).delay(0.15)){
                    alpha = 1
                }
                if inShoppingList == false{
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
                } else {
                    // only runs for shopping list to change the core data object
                    PersistenceController.shared.updateShoppingListItem(mealName: mealName,
                                                                        ingredient: ingredient,
                                                                        measurement: measurement,
                                                                        checkedOff: selected)
                    shopping.getShoppingList()
                }
            }
        }
        .onAppear{
            getImage(ingredientName: ingredient)
            if inShoppingList == false{
                selected = shopping.checkShoppingList(mealName: mealName,
                                                      ingredient: ingredient)
            }
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
