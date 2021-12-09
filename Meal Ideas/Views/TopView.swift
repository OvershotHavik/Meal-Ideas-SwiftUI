//
//  TopView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/22/21.
//

import SwiftUI

struct TopView: View {
    @State var search = ""
    @State private var isActive = false
    
    var body: some View {
        VStack{
            SelectedQueryView(isActive: $isActive)
            
            Divider()
            Spacer()
            
            TopViewButtons()
        }
        .background(Color.blue)
        .frame(height: 75)
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}

struct SelectedQueryView: View{
    @EnvironmentObject var query: Query
    @Binding var isActive : Bool
    var body: some View{
        switch query.query{
        case .random:
            Button {
                //perform network call to get more meals
            } label: {
                Text("Get more random Meals")
                    .foregroundColor(.primary)
            }
            
        case .category:
            HStack{
                NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: .categories))) {
                    Text("Select a category")
                        .foregroundColor(.primary)
                }
                if let safeSelected = query.selected{
                    Text(safeSelected)
                }
            }
            
        case .ingredient:
            HStack{
                
                NavigationLink(destination: SingleIngredientListView(vm: IngredientListVM(editIdeaVM: EditIdeaVM(meal: nil)))) {
                    Text("Select an ingredient")
                        .foregroundColor(.primary)
                }
                if let safeSelected = query.selected{
                    Text("Selected: \(safeSelected)")
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
        }
    }
}




struct TopViewButtons: View{
    @EnvironmentObject var query : Query
    //    var query = QueryType.favorite.rawValue
    var body: some View{
        //When button is pressed, transition the top view to show the options available for the respective choice
        HStack(spacing: 0){
            QueryButtonView(title: .random)
            
            QueryButtonView(title: .category)
            
            QueryButtonView(title: .ingredient)
            
            QueryImageButtonView(title: .favorite)
                .foregroundColor(.pink)
            
            QueryImageButtonView(title: .history)
            
            
        }
        .padding(.bottom, 5)
        .foregroundColor(.primary)
    }
}
