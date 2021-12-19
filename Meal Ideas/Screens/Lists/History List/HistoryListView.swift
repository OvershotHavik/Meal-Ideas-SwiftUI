//
//  HistoryListView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/19/21.
//

import SwiftUI

struct HistoryListView: View {
    @StateObject var vm: HistoryListVM
    var source: Source
    
    var body: some View {
        Text("Source: \(source.rawValue)")
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView(vm: HistoryListVM(), source: .myIdeas)
    }
}
