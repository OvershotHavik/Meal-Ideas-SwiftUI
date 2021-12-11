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
        List(vm.listItems, id: \.self) {item in
            HStack {
                Text(item)
                Spacer()
                Image(systemName: vm.selectedArray.contains(item) ? "checkmark" : "")
            }

//            Image(systemName: inHistory ? "book" : "") // If in history is true, then show book, if not, show nothing
//            Image(vm.selectedArray.contains(item) ? systemName: "" : systemName: "checkmark")
//                .listRowBackground(vm.multiSelection.contains(item)  ? Color.green : Color.clear) // works
//                .listRowBackground(vm.selectedArray.contains(item)  ? Color.green : Color.clear) // works
                .onTapGesture {
                    vm.checkArray(item: item)
                }
            // TODO:  could maybe change this to show a check mark on the cell or something, would need to create said cell..
        }
        .navigationTitle(title.rawValue)
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar{ EditButton()}

    }
}
/*
struct MultiChoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        MultiChoiceListView()
    }
}
*/
