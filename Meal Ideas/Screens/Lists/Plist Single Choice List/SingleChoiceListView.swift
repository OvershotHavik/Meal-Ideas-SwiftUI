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
    var title: Titles
    @Environment(\.dismiss) var dismiss

    var body: some View {
            VStack{
                List(vm.listItems, id: \.self, selection: $vm.singleChoiceString) {item in
                    HStack{
                        Text(item)
                        Spacer()
                        if query.selected == item{
                            Image(systemName: "checkmark")
                        }
                    }
                    .onTapGesture{
                        query.selected = item
                        dismiss()
                    }
                }
            }
            .navigationTitle(title.rawValue)
            .navigationBarTitleDisplayMode(.inline)
    }
}
/*
struct SingleChoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleChoiceListView()
    }
}
*/