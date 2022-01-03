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
    @Binding var getMoreMeals : Bool
    @Binding var source: Source
    var body: some View {
        ZStack{
            BackgroundGradientView()
            VStack{
                Spacer(minLength: 20)
                Text("Meal Ideas")
                    .font(.title)
//                Spacer()
//                SelectedQueryView(isActive: $isActive,
//                                  keywordSearchTapped: $keywordSearchTapped,
//                                  getMoreMeals: $getMoreMeals,
//                                  source: $source)

                KeywordSearchView(keywordSearchTapped: $keywordSearchTapped,
                                  source: $source,
                                  getMoreMeals: $getMoreMeals)

                
                TopViewButtons(getMoreMeals: $getMoreMeals)
            }
        }
        .frame(height: 100)
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(keywordSearchTapped: .constant(false), getMoreMeals: .constant(false), source: .constant(.spoonacular))
    }
}
/*
struct SelectedQueryView: View{
    @EnvironmentObject var query: Query
    @Binding var isActive : Bool
    @Binding var keywordSearchTapped : Bool
    @Binding var getMoreMeals : Bool
    @Binding var source: Source
    var body: some View{
        switch query.queryType{
        case .none:
            Text("")
        case .random:
            GetMoreMealsButton(getMoreMeals: $getMoreMeals)
        case .category:
            HStack{
                Spacer()
                NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: .categories), title: .oneCategory)) {
                    Text("Select a category")
                        .foregroundColor(.primary)
                }
                Spacer()

                if let safeSelected = query.selected{
                    Text(safeSelected)
                    GetMoreMealsButton(getMoreMeals: $getMoreMeals)
                    Spacer()
                }
            }
            
        case .ingredient:
            HStack{
                Spacer()
                NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(editIdeaVM: EditIdeaVM(meal: nil)))) {
                    Text("Select an ingredient")
                        .foregroundColor(.primary)
                }
                if let safeSelected = query.selected{
                    Text(safeSelected)
                }
                Spacer()

                if source == .spoonacular && query.selected != nil{
                    GetMoreMealsButton(getMoreMeals: $getMoreMeals)
                    Spacer()
                }
            }
        case .history:
            HStack{
                Button {
                    //bring up list view of history
                } label: {
                    Text("View History") // or maybe just change the bottom view to the list..? not sure yet
                        .foregroundColor(.primary)
                }
                
            }
        case .favorite:
            HStack{
                Button {
                    //bring up list view of favorites
                } label: {
                    Text("View Favorites") // or maybe just change the bottom view to the list..? not sure yet
                        .foregroundColor(.primary)
                }
                
            }
        case .keyword:
            KeywordSearchView(keywordSearchTapped: $keywordSearchTapped,
                              source: $source,
                              getMoreMeals: $getMoreMeals)
        }
    }
}
*/


// MARK: - Top View Buttons
struct TopViewButtons: View{
    @Binding var getMoreMeals: Bool

    var body: some View{
        HStack{
            Spacer()
            RandomQueryButtonView(getMoreMeals: $getMoreMeals)
            
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
    @Binding var source: Source
    @Binding var getMoreMeals : Bool
    @State var searchTapped = false
    var body: some View{
        HStack{
            Spacer()
            TextField("Keyword Search", text: $query.keyword)
                .frame(width: 250)
            Button {
                query.selected = nil
                searchTapped = true
                keywordSearchTapped.toggle()
                print("Top View Keyword search: \(query.keyword)")
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
            }

            Spacer()
//
//            if source == .spoonacular && searchTapped == true{
//                GetMoreMealsButton(getMoreMeals: $getMoreMeals)
//                Spacer()
//
//            }
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
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(.primary)
        }
    }
}
