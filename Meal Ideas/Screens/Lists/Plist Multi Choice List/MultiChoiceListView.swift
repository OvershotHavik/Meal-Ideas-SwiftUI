//
//  MultiChoiceListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI

struct MultiChoiceListView: View {
    @StateObject var vm: MultiChoiceListVM
    @EnvironmentObject var editIdeaVM: EditIdeaVM
    var title: Titles
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List(vm.searchResults, id: \.self) {item in
            HStack {
                Text(item)
                Spacer()
                if vm.selectedArray.contains(item){
                    Image(systemName: "checkmark")
                }
            }
                .onTapGesture {
                    vm.checkArray(item: item)
                }
        }
        .searchable(text: $vm.searchText)
        .navigationTitle(title.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
/*
struct MultiChoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        MultiChoiceListView()
    }
}
*/
