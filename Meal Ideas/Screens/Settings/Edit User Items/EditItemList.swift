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
            .onDelete{IndexSet in
                PersistenceController.shared.deleteInList(indexSet: IndexSet, entityName: vm.entityName)
                vm.listItems.remove(atOffsets: IndexSet)
            }
        }
        .alert(isPresented: $vm.showTextAlert,
               TextAlert(title: "Add a new \(vm.listType)", message: "This will be available for future meals", action: { result in
            if let text = result{
                print("Add \(vm.listType): \(text)")
                vm.addItem(item: text)
            }
        }))
        
        .searchable(text: $vm.searchText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text(vm.title.rawValue)
            })
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    print("Bring up the new item alert with text field")
                    vm.showTextAlert.toggle()
                } label: {
                    Image(systemName: "plus")
                }

            }
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
