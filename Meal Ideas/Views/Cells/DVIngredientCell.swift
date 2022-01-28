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
    @State var image : UIImage?
    
    var body: some View {
            ZStack(alignment: .leading){
                HStack{
                    NavigationLink(destination: ZoomImageView(image: image ?? UIImage(imageLiteralResourceName: "Placeholder"))){
                        
                        Image(uiImage: image ?? UIImage(imageLiteralResourceName: "Placeholder"))
                            .resizable()
                    }
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
                .contentShape(Rectangle())
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
