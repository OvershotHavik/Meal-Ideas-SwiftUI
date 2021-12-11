//
//  MultiChoiceListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import Foundation
import SwiftUI

final class  MultiChoiceListVM: ObservableObject {
//    @EnvironmentObject var editIdeaVM: EditIdeaVM
    @ObservedObject var editVM: EditIdeaVM
    @Published var listItems: [String] = []
    @Published var PList: PList
    @Published var selectedArray: [String] = [] // updates based on the plist selected
    
    init(PList: PList, editIdeaVM: EditIdeaVM){
        self.PList = PList
        self.editVM = editIdeaVM
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
        switch PList{
        case .categories:
            selectedArray = editVM.categories
        case .sides:
            selectedArray = editVM.sides
        default: print("plist selection array not setup in MultiChoiceListVM")
        }
    }
    
    func checkArray(item: String){
        //updates the array on the editIdeaVM as well as selectedArray to have the list view respond accordingly
        
        switch PList{
        case .categories:
            if let repeatItem = editVM.categories.firstIndex(of: item){
                editVM.categories.remove(at: repeatItem)
                print("duplicate item: \(item), removed from array")
            } else {
                editVM.categories.append(item)
                editVM.categories = editVM.categories.sorted{$0 < $1}
                print("added item: \(item)")
            }
            selectedArray = editVM.categories
            
            
        case .sides:
            if let repeatItem = editVM.sides.firstIndex(of: item){
                editVM.sides.remove(at: repeatItem)
                print("duplicate item: \(item), removed from array")
            } else {
                editVM.sides.append(item)
                editVM.sides = editVM.sides.sorted{$0 < $1}
                print("added item: \(item)")
            }
            selectedArray = editVM.sides

            
        default: print("plist selection checkArray  not setup in MultiChoiceListVM")
        }
//        if let repeatItem = editIdeaVM.categories.firstIndex(of: item){
//            editIdeaVM.categories.remove(at: repeatItem)
//            print("duplicate item: \(item), removed from array")
//        } else {
//            editIdeaVM.categories.append(item)
//            print("added item: \(item)")
//        }
//        selectedArray = editIdeaVM.categories
//        print(editIdeaVM.categories)

    }
}