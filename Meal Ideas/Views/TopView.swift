//
//  TopView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct TopView: View{
    @EnvironmentObject var query : Query
    @Binding var keywordSearchTapped: Bool
    @Binding var getRandomMeals : Bool
    @Binding var source: Source
    var body: some View{
        HStack(spacing: 20){
            Button(action: {
                print("Surprise me tapped")
                query.queryType = .random
                query.selected = ""
                getRandomMeals.toggle()
            }, label: {
                Text("Surprise \nMe")
                    .lineLimit(2)
            })
//                .buttonStyle(.borderedProminent)
//                .accentColor(Color(uiColor: Color.lightBlue))

            TextField("Search...", text: $query.keyword)
                .textFieldStyle(CustomRoundedCornerTextField())
                .onSubmit {
                    query.selected = query.keyword
                    query.queryType = .keyword
                    keywordSearchTapped.toggle()
                    print("Top View Keyword search: \(query.keyword)")
                }
            Menu{
                Button {
                    query.menuSelection = .category
                    query.queryType = .category
                    print("category selected")
                } label: {
                    if query.queryType == .category{
                        Text("\(QueryType.category.rawValue) - \(query.selected)")
                    } else {
                        Text(QueryType.category.rawValue)
                    }
                }
                
                Button {
                    query.menuSelection = .ingredient
                    query.queryType = .ingredient
                    print("Ingredient selected")
                } label: {
                    if query.queryType == .ingredient{
                        Text("\(QueryType.ingredient.rawValue) - \(query.selected)")
                    } else {
                        Text(QueryType.ingredient.rawValue)
                    }
                }
                
                Button {
                    query.menuSelection = .custom
                    query.queryType = .custom
                    print("Custom selected")
                } label: {
                    if query.queryType == .custom{
                        Text("\(QueryType.custom.rawValue) ->")
                    } else {
                        Text(QueryType.custom.rawValue)
                    }
                    
                }
                


                } label: {// Menu label
                Image(systemName: "slider.horizontal.3")
//                        .padding(14)
//                        .background(Color(uiColor: Color.lightBlue))
//                        .cornerRadius(10)
            }
                .font(.title)
            
        }
        .padding()
        .foregroundColor(.primary)
        .background(BackgroundGradientView())
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
