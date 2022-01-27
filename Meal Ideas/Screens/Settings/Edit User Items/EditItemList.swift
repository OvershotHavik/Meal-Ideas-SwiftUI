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
                ZStack{
                    Color(uiColor: .secondarySystemBackground)
                    HStack{
                        Text(item)
                        Spacer()
                    }


                }
                .onTapGesture {
                    print("item tapped: \(item)")
                    vm.itemToEdit = item
                    vm.showEditAlert.toggle()
                }
            }
            .onDelete{IndexSet in
                PersistenceController.shared.deleteInList(indexSet: IndexSet, entityName: vm.entityName)
                vm.listItems.remove(atOffsets: IndexSet)
            }
            
        }
        //Add a new item
        .alert(isPresented: $vm.showTextAlert,
               TextAlert(title: "Add a new \(vm.listType)", message: "This will be available for future meals", action: { result in
            if let text = result{
                print("Add \(vm.listType): \(text)")
                vm.addItem(item: text)
            }
        }))
        //Edit Item
        .alert(isPresented: $vm.showEditAlert,
               TextAlert(title: "Edit Item",
                         message: "Any changes will update meals with this item",
                         text: vm.itemToEdit,
                         accept: "Update",
                         secondaryActionTitle: "Delete",
                         action: { Result in
            //Update tapped
            if let updated = Result{
                print("New edit \(updated)")
                print("Original item to edited: \(vm.itemToEdit)")
                //pass both the new text and the original so we can cycle through the meals to remove the old, and add the new
                PersistenceController.shared.editUserItem(entityName: vm.entityName,
                                                          original: vm.itemToEdit,
                                                          updated: updated)
                vm.getUserItems() // once updated, get the list again
                vm.showEditAlert = false
            }
            
        },
                         //Delete Tapped
                         secondaryAction: {
            print("Delete tapped")
            PersistenceController.shared.editUserItem(entityName: vm.entityName,
                                                      original: vm.itemToEdit,
                                                      updated: nil)
            vm.getUserItems() // once updated, get the list again
            vm.showEditAlert = false
        }
                        )
        )
        
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
