//
//  EditItemList.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import SwiftUI

struct EditItemList: View {
    @StateObject var vm : EditItemListVM
    var body: some View {
        List {
            if vm.listItems.isEmpty{
                NoResultsView(message: "Tap the + to add a custom item")
            }
            ForEach(vm.searchResults, id: \.self) { item in
                Text(item)
            }
        }
        .searchable(text: $vm.searchText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text(vm.title.rawValue)
            })
        }
    }
}
/*
struct EditItemList_Previews: PreviewProvider {
    static var previews: some View {
        EditItemList()
    }
}
*/
