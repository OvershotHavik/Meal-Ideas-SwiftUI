//
//  MyIdeasDetailView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/23/21.
//

import SwiftUI

struct MyIdeasDetailView: View {
    
    @ObservedObject var vm : MyIdeasDetailVM
    
    var body: some View {
        VStack{
            ScrollView{
                Image(vm.meal.mealPhoto)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                
                Text(vm.meal.mealName)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding([.bottom, .horizontal], 5)
                HStack{
                    ForEach(vm.meal.category, id: \.self) {cat in
                        Text(cat)
                            .background(.cyan)
                    }
                    ForEach(vm.meal.ingredients, id: \.self){ing in
                        Text(ing)
                            .background(.green)
                    }
                }
                Text(vm.meal.recipe)
                    .font(.body)
                
            }
            Link(destination: URL(string: vm.meal.source ?? "https://www.google.com")!) {
                Text("Visit Source")
            }
            .padding()
        }
    }
}

struct MyIdeasDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasDetailView(vm: MyIdeasDetailVM(meal: MockData.userMealSample))
    }
}
