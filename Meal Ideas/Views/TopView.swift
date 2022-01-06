//
//  TopView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct TopView: View {
    @State private var isActive = false
    @Binding var keywordSearchTapped: Bool
    @Binding var getRandomMeals : Bool
    @Binding var source: Source
    var body: some View {
        ZStack{
            BackgroundGradientView()
            VStack{
                Spacer(minLength: 20)
                Text("Meal Ideas")
                    .font(.title)
                
                KeywordSearchView(keywordSearchTapped: $keywordSearchTapped)

                
                TopViewButtons(getRandomMeals: $getRandomMeals)
            }
        }
        .frame(height: 100)
        
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(keywordSearchTapped: .constant(false), getRandomMeals: .constant(false), source: .constant(.spoonacular))
    }
}



// MARK: - Top View Buttons
struct TopViewButtons: View{
    @Binding var getRandomMeals: Bool

    var body: some View{
        HStack{
            Spacer()
            RandomQueryButtonView(getRandomMeals: $getRandomMeals)
            
            Spacer()
            
            CategoryQueryButtonView()
            
            Spacer()
            
            IngredientQueryButtonView()
            
            Spacer()
        }
        .padding(.bottom, 5)
        
    }
}


// MARK: - Keyword Search View

struct KeywordSearchView: View{
    @EnvironmentObject var query : Query
    @Binding var keywordSearchTapped : Bool
    @State var searchTapped = false
    var body: some View{
        HStack{
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Keyword Search", text: $query.keyword)
                .textFieldStyle(.roundedBorder)
                .frame(width: 250)
                .onSubmit {
                    query.selected = nil
                    searchTapped = true
                    keywordSearchTapped.toggle()
                    print("Top View Keyword search: \(query.keyword)")
                }
            Spacer()
        }
    }
}


// MARK: - Get More Meals Button
struct GetMoreMealsButton: View{
    @Binding var getMoreMeals: Bool
    var body: some View{
        Button {
            //perform network call to get more meals
            getMoreMeals.toggle()
        } label: {
//            Image(systemName: "arrow.triangle.2.circlepath")
            Image(systemName: "shuffle")
                .foregroundColor(.primary)
        }
    }
}
