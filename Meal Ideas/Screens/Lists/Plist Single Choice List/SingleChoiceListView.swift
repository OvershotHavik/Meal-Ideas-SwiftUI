//
//  SingleChoiceListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI

struct SingleChoiceListView: View {
    @StateObject var vm: SingleChoiceListVM
    @EnvironmentObject var query: Query
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            if vm.listItems.isEmpty{
                NoResultsView(message: Messages.noCategory.rawValue)
            }
            List(vm.searchResults, id: \.self, selection: $vm.singleChoiceString) {item in
                HStack{
                    Text(item)
                    Spacer()
                    if query.selected == item{
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture{
                    query.selected = item
                    query.customCategory = item // manually setting for category right now, may need to change if using this elsewhere for something else
                    dismiss()
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text(vm.title.rawValue)
            }
        }
        .searchable(text: $vm.searchText)
        .navigationBarTitleDisplayMode(.inline)
    }
}
