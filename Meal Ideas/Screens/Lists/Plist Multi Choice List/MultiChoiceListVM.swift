//
//  MultiChoiceListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI
import CoreData

final class  MultiChoiceListVM: ObservableObject {
    @ObservedObject var editVM: EditIdeaVM
    @Published var listItems: [String] = []
    @Published var PList: PList
    @Published var selectedArray: [String] = [] // updates based on the plist selected
    @Published var searchText = ""
    
    //For the alert to add items to the list
    @Published var showTextAlert = false
    @Published var listType: ListType
    @Published var userSides: [String] = []
    @Published var userCategories: [String] = []
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return listItems
        } else {
            return listItems.filter { $0.containsIgnoringCase(find: searchText) }
        }
    }
    
    
    init(PList: PList, editIdeaVM: EditIdeaVM, listType: ListType){
        self.PList = PList
        self.editVM = editIdeaVM
        self.listType = listType
        getSides()
        getCategories()
        fetchPlist()
    }


    private func fetchPlist(){
        PListManager.loadItemsFromLocalPlist(XcodePlist: PList,
                                             classToDecodeTo: [NewItem].self,
                                             completionHandler: { [weak self] result in
            if let self = self {
                switch result {
                case .success(let itemArray):
                    self.listItems = itemArray.map{$0.itemName}
                    switch self.listType{
                        
                    case .side:
                        self.listItems.append(contentsOf: self.userSides)
                    case .ingredient:
                        () // done in multi ingredient VM
                    case .category:
                        self.listItems.append(contentsOf: self.userCategories)
                        
                    }
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
    }


    private func getSides(){
        let request = NSFetchRequest<CDSides>(entityName: EntityName.CDSides.rawValue)
        do {
            let sides = try PersistenceController.shared.container.viewContext.fetch(request)
            userSides = sides.compactMap({$0.side})
            print("User sides: \(userSides)")
            
            print("sides count: \(userSides.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    

    private func getCategories(){
        let request = NSFetchRequest<CDCategory>(entityName: EntityName.CDCategory.rawValue)
        do {
            let categories = try PersistenceController.shared.container.viewContext.fetch(request)
            userCategories = categories.compactMap{$0.category}
            print("user categories: \(userCategories)")
            print("categories count: \(userCategories.count)")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }


    func addItem(item: String){
        selectedArray.append(item)

        if listItems.firstIndex(of: item) == nil{
            //only add if the item isn't already in the core data
            if listType == .category{
                editVM.categories.append(item)
                PersistenceController.shared.addUserItem(entityName: .CDCategory, item: item)
            }
            if listType == .side{
                editVM.sides.append(item)
                PersistenceController.shared.addUserItem(entityName: .CDSides, item: item)
            }
            listItems.append(item)
            listItems = listItems.sorted{$0 < $1}
        }
    }
}
