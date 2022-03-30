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
        List(vm.searchResults.sorted{$0 < $1}, id: \.self) {item in
            HStack {
                if vm.selectedArray.contains(item){
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
            .contentShape(Rectangle())
            .onTapGesture {
                vm.checkArray(item: item)
            }
        }
        .alert(isPresented: $vm.showTextAlert,
               TextAlert(title: "Add a new \(vm.listType)", message:  "This will be added to this meal. \nThis will also be available for future meals", action: { result in
            if let text = result{
                vm.addItem(item: text)
            }
        }))
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text(title.rawValue)
            }
            
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    print("Bring up the new item alert with text field")
                    vm.showTextAlert.toggle()
                } label: {
                    Image(systemName: SFSymbols.plus.rawValue)
                }
            }
        }
        .searchable(text: $vm.searchText)
        .navigationBarTitleDisplayMode(.inline)
    }
}
