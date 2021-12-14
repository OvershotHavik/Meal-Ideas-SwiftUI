//
//  SingleChoiceListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI

final class  SingleChoiceListVM: ObservableObject {

    @Published var listItems: [String] = []
    @Published var PList: PList
//    @Published var singleChoice: NewItem?
    @Published var singleChoiceString: String?
//    @Published var multi = Set<String>()
    
    @Published var searchText = ""
    var searchResults: [String] {
        if searchText.isEmpty {
            return listItems
        } else {
            return listItems.filter { $0.contains(searchText) }
        }
    }
    init(PList: PList){
        self.PList = PList
        fetchPlist()
    }
    
    func fetchPlist(){
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

