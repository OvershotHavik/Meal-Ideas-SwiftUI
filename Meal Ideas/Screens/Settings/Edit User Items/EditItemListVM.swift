//
//  EditItemListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import Foundation

@MainActor final class EditItemListVM: ObservableObject{
    @Published var title: Titles
    @Published var listItems: [String]
    @Published var searchText = ""
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return listItems
        } else {
            return listItems.filter { $0.contains(searchText) }
        }
    }
    init(title: Titles, listItems: [String]){
        self.title = title
        self.listItems = listItems
    }
    
}
