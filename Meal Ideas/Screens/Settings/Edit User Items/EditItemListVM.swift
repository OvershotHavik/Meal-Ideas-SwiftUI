//
//  EditItemListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/26/22.
//

import Foundation
import CoreData

@MainActor final class EditItemListVM: ObservableObject{
    @Published var title: Titles
    @Published var listItems: [String] = []
    @Published var searchText = ""
    @Published var listType: ListType
    @Published var showTextAlert = false
    @Published var entityName: EntityName
    @Published var itemToEdit: String = ""
    @Published var showEditAlert = false
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return listItems
        } else {
            return listItems.filter { $0.contains(searchText) }
        }
    }
    init(title: Titles, listType: ListType, entityName: EntityName){
        self.title = title
        self.listType = listType
        self.entityName = entityName
        getUserItems()
    }
    
    
    func getUserItems(){
        switch listType {
        case .category:
            let categoriesRequest = NSFetchRequest<CDCategory>(entityName: EntityName.CDCategory.rawValue)
            do {
                let categories = try PersistenceController.shared.container.viewContext.fetch(categoriesRequest)
                listItems = categories.compactMap{$0.category}
                print("categories count: \(listItems.count)")
            } catch let error {
                print("error fetching: \(error.localizedDescription)")
            }
            
            
        case .ingredient:
            let ingredientRequest = NSFetchRequest<CDIngredient>(entityName: EntityName.CDIngredient.rawValue)
            do {
                let ingredients = try PersistenceController.shared.container.viewContext.fetch(ingredientRequest)
                listItems = ingredients.compactMap({$0.ingredient})
                print("user ingredient count: \(listItems.count)")
            } catch let error {
                print("error fetching: \(error.localizedDescription)")
            }
            
            
        case .side:
            let sidesRequest = NSFetchRequest<CDSides>(entityName: EntityName.CDSides.rawValue)
            do {
                let sides = try PersistenceController.shared.container.viewContext.fetch(sidesRequest)
                listItems = sides.compactMap({$0.side})
                print("sides count: \(listItems.count)")
            } catch let error {
                print("error fetching: \(error.localizedDescription)")
            }
        }
    }
    // MARK: - Add Item
    func addItem(item: String){
        listItems.append(item)
        listItems = listItems.sorted{$0 < $1}
        switch listType {
        case .category:
            PersistenceController.shared.addUserItem(entityName: .CDCategory, item: item)
        case .ingredient:
            PersistenceController.shared.addUserItem(entityName: .CDIngredient, item: item)
        case .side:
            PersistenceController.shared.addUserItem(entityName: .CDSides, item: item)
        }
    }
}
