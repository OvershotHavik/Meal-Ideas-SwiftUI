//
//  MultiChoiceListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import SwiftUI

struct MultiChoiceListView: View {
    @StateObject var vm: MultiChoiceListVM

    @Environment(\.dismiss) var dismiss

    var body: some View {
        List(vm.listItems, id: \.self, selection: $vm.multi) {item in
            Text(item)
                .listRowBackground(vm.multi.contains(item)  ? Color.green : Color.clear) // works
            // TODO:  could maybe change this to show a check mark on the cell or something, would need to create said cell..
        }

        .navigationTitle("Select One")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{ EditButton()}

    }
}
/*
struct MultiChoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        MultiChoiceListView()
    }
}
*/
