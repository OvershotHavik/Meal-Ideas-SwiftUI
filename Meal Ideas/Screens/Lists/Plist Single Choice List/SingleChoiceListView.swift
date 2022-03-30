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
            List(vm.searchResults.sorted{$0 < $1}, id: \.self, selection: $vm.singleChoiceString) {item in
                HStack{
                    if query.selected == item{
                        withAnimation(.easeIn(duration: 0.25).delay(0.25)){
                            Image(systemName: SFSymbols.check.rawValue)
                            .padding(.horizontal, 5)
                        }
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 18)
                            .padding(.horizontal, 5)
                    }
                    Text(item)
                }
                .contentShape(Rectangle().size(width: .infinity, height: .infinity))
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
