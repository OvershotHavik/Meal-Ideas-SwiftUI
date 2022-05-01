//
//  SingleChoiceListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI

final class SingleChoiceListVM: ObservableObject {
    @Published var listItems: [String]
    @Published var PList: PList?
    @Published var title: Titles
    @Published var singleChoiceString: String?
    @Published var searchText = ""
    var searchResults: [String] {
        if searchText.isEmpty {
            return listItems
        } else {
            return listItems.filter { $0.containsIgnoringCase(find: searchText) }
        }
    }
    
    init(PList: PList?, listItems: [String], singleChoiceString: String?, title: Titles){
        self.PList = PList
        self.listItems = listItems
        self.singleChoiceString = singleChoiceString
        self.title = title
        fetchPlist()
    }
    
    
    private func fetchPlist(){
        if let PList = PList {
            PListManager.loadItemsFromLocalPlist(XcodePlist: PList,
                                                 classToDecodeTo: [NewItem].self,
                                                 completionHandler: { [weak self] result in
                if let self = self {
                    switch result {
                    case .success(let itemArray):
                        self.listItems = itemArray.map{$0.itemName}
                    case .failure(let e): print(e)
                    }
                }
            })
        }
    }
}

