//
//  MyIdeasView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/19/21.
//

import SwiftUI

struct MyIdeasView: View {
   
    var body: some View {
        NavigationView{
            VStack{
                TopView()
                let columns = [GridItem(), GridItem()]
                ScrollView{
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(MockData.testUerArray) {meal in
                            MealCardView(userMeal: meal)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .padding(.horizontal)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MyIdeasView_Previews: PreviewProvider {
    static var previews: some View {
        MyIdeasView()
    }
}
