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
                List(vm.listItems, id: \.self, selection: $vm.singleChoiceString) {item in
                    Text(item)
//                        .listRowBackground(query.selected == item ? Color.green : Color.clear) // works
                        .onTapGesture{
                            query.selected = item
                            dismiss()
                        }
                }
            }
            .navigationTitle("Select One")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar{ EditButton()}
        
        

    }
}
/*
struct SingleChoiceListView_Previews: PreviewProvider {
    static var previews: some View {
        SingleChoiceListView()
    }
}
*/
