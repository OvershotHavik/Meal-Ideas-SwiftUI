//
//  MealCardView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//
import SwiftUI

final class MealCardVM: ObservableObject{
    @Published var finished = false
    @Published var mealPhoto: String
    @Published var mealPhotoData: Data?
    @Published var image: UIImage?
    @Published var mealName: String
    @Published var favorited: Bool
    @Published var inHistory: Bool
    init(mealPhoto: String, mealPhotoData: Data?, mealName: String, favorited: Bool, inHistory: Bool ){
        self.mealPhoto = mealPhoto
        self.mealPhotoData = mealPhotoData
        self.mealName = mealName
        self.favorited = favorited
        self.inHistory = inHistory
    }
    
    func loadImage(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let safeData = self?.mealPhotoData{
                let tempImage = UIImage(data: safeData)
                DispatchQueue.main.async { [weak self] in
                    self?.image = tempImage
                }
            }
        }
    }
}

struct MealCardView: View {
    @StateObject var vm : MealCardVM
    
    

    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
                .opacity(0.25)

            VStack{
                HistoryFavoriteHStack(inHistory: vm.inHistory,
                                      favorited: vm.favorited)
                if vm.image != nil{
                    Image(uiImage: vm.image ?? UIImage(imageLiteralResourceName: UI.placeholderMeal))
//                    if let safeData = mealPhotoData{
//                        Image(uiImage: (UIImage(data: safeData) ?? UIImage(imageLiteralResourceName: UI.placeholderMeal)))
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
//                    }
                } else {
                    
                    LoadRemoteImageView(urlString: vm.mealPhoto)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                }

                Text(vm.mealName)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding([.bottom, .horizontal], 5)
            }
        }
        .onAppear{
            if vm.mealPhotoData != nil{
                vm.loadImage()
            }
        }
        .frame(width: 160, height: 210)
        .cornerRadius(10)
//        .shadow(color: .black, radius: 5, x: 0, y: 0)
    }
}
/*
struct MealCardView_Previews: PreviewProvider {
    static var previews: some View {
        MealCardView(vm: MealCardVM(mealPhoto: <#String#>, mealPhotoData: <#Data?#>, mealName: <#String#>, favorited: <#Bool#>, inHistory: <#Bool#>))
    }
}
 */
// MARK: - History Favorites H Stack
struct HistoryFavoriteHStack: View{
    
    //need to change accordingly
    var inHistory: Bool
    var favorited: Bool
    var body: some View{
        HStack{
            if inHistory == true {
                Image(systemName: "book") // If in history is true, then show book, if not, show nothing
                    .padding([.leading, .top])
                    .opacity(0.50)
            }
            Spacer()
            Text("")
            Spacer()
            if favorited == true {
                Image(systemName:"heart.fill") // If favorited is true, then show book, if not, show nothing
                    .foregroundColor(.pink)
                    .padding([.trailing, .top])
            }

        }
    }
}
