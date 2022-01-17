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
//            BackgroundGradientView()
            KeywordSearchView(keywordSearchTapped: $keywordSearchTapped,
                              getRandomMeals: $getRandomMeals)

        }
//                Spacer(minLength: 10)
//                Text("Meal Ideas")
//                    .font(.title)
                
        
            
//                    .frame(height: 150)

                
//                TopViewButtons(getRandomMeals: $getRandomMeals)
            
//        }
        
    }
}


struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(keywordSearchTapped: .constant(false), getRandomMeals: .constant(false), source: .constant(.spoonacular))
    }
}


/*
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
*/

// MARK: - Keyword Search View

struct KeywordSearchView: View{
    @EnvironmentObject var query : Query
    @Binding var keywordSearchTapped : Bool
    @Binding var getRandomMeals: Bool
    var body: some View{
        HStack(spacing: 20){
            Button(action: {
                // do random
                print("Surprise me tapped")
                query.queryType = .random
                query.selected = ""
                getRandomMeals.toggle()
            }, label: {
                Text("Surprise \nMe")
                    .lineLimit(2)
            })
                .foregroundColor(.primary)
            TextField("Search...", text: $query.keyword)
                .textFieldStyle(CustomRoundedCornerTextField())
                .onSubmit {
                    query.selected = ""
                    query.queryType = .keyword
                    keywordSearchTapped.toggle()
                    print("Top View Keyword search: \(query.keyword)")
                }
            Button  {
                //bring up a menu for the user to select category or ingredient to then take them to the list views
                print("Filter tapped")
            } label: {
                Image("Filter")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
//            Spacer()
        }
        .padding()
    }
}




// MARK: - Keyword Search View
/*
struct KeywordSearchView: View{
    @EnvironmentObject var query : Query
    @Binding var keywordSearchTapped : Bool
    var body: some View{
        HStack{
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search...", text: $query.keyword)
                .textFieldStyle(CustomRoundedCornerTextField())
//                .frame(width: 250)
                .onSubmit {
                    query.selected = ""
                    query.queryType = .keyword
                    keywordSearchTapped.toggle()
                    print("Top View Keyword search: \(query.keyword)")
                }
            Spacer()
            // Random icon - Search - Filter
            //use a menu to choose which ingredient or category
            
        }
    }
}
*/
