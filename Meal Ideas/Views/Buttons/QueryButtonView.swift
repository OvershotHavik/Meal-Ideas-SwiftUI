//
//  QueryButtonView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

// MARK: - Random Query Button
struct RandomQueryButtonView: View{
    @Binding var getRandomMeals: Bool
    @EnvironmentObject var query: Query
    var body: some View{
        Button {
            query.queryType = .random
            query.selected = ""
            getRandomMeals.toggle()

        } label: {
            VStack{
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.primary)
                    .frame(width: 30, height: 30)
                Text(QueryType.random.rawValue)
                    .foregroundColor(.primary)
            }
            
        }
        .modifier(QueryButtonModifier(title: .random))
    }
}

// MARK: - Category Query Button
struct CategoryQueryButtonView: View{
    @EnvironmentObject var query: Query
    var body: some View{
        
        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: .categories), title: .oneCategory)) {
            VStack(spacing: 5){
                if query.queryType == .category{
                    if let safeSelected = query.selected{
                        Text(safeSelected)
                            .foregroundColor(.primary)
                            .offset(y: 5)
                    }
                }
                Image(systemName: "c.circle")
                    .foregroundColor(.primary)
                    .frame(width: 30, height: 30)
                Text(QueryType.category.rawValue)
                    .foregroundColor(.primary)
                    .offset(y: (query.queryType == .category) ? -7 : 0)
            }
        }
        .modifier(QueryButtonModifier(title: .category))
    }
}

// MARK: - Ingredient Query Button
struct IngredientQueryButtonView : View{
    @EnvironmentObject var query: Query
    var body: some View{
        NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(editIdeaVM: EditIdeaVM(meal: nil)))) {
            VStack(spacing: 5){
                if query.queryType == .ingredient{
                    if let safeSelected = query.selected{
                        Text(safeSelected)
                            .foregroundColor(.primary)
                            .offset(y: 5)
                    }
                }
                Image(systemName: "i.circle")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.primary)
                Text(QueryType.ingredient.rawValue)
                    .foregroundColor(.primary)
                    .offset(y: (query.queryType == .ingredient) ? -7 : 0)
            }
            .modifier(QueryButtonModifier(title: .ingredient))
        }
    }
}

// MARK: - Query Button Modifier
struct QueryButtonModifier: ViewModifier{
    var title: QueryType
    @EnvironmentObject var query : Query
    func body(content: Content) -> some View{
        content
            .frame(width: 90, height: 90)
            .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: .systemGray6), Color(uiColor: .systemGray2)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(20)
            .offset(y: 45)
            .opacity((query.queryType.rawValue == title.rawValue) ? 1 : 0.5)
    }
}
