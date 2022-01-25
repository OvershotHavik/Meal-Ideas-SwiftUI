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
                    .background(Color(uiColor: .secondarySystemBackground))
                Spacer()
                if vm.selectedArray.contains(item){
                    Image(systemName: "checkmark")
                }
            }
                .onTapGesture {
                    vm.checkArray(item: item)
                }
                
        }
        .alert(isPresented: $vm.showTextAlert,
               TextAlert(title: "Add a new \(vm.listType)", message:  "This will be added to this meal. \nThis will also be available for future meals", action: { result in
            if let text = result{
                if vm.listType == .sides{
                    print("Side entered: \(text)")
                }
                if vm.listType == .category{
                    print("category entered: \(text)")
                }
            }
        }))
        .toolbar{

            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    print("Bring up the new item alert with text field")
                    vm.showTextAlert.toggle()
                } label: {
                    Image(systemName: "plus")
                }

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
