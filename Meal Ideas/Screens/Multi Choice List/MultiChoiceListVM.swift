//
//  MultiChoiceListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import Foundation

final class  MultiChoiceListVM: ObservableObject {

    @Published var listItems: [String] = []
    @Published var PList: PList
//    @Published var singleChoice: NewItem?
//    @Published var singleChoiceString: String?
    @Published var multi = Set<String>()
    
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
