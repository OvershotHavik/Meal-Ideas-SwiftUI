//
//  MenuCategoryNL.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/6/22.
//

import SwiftUI

struct MenuCategoryNL: View{
    @EnvironmentObject var query: Query
    var plist: PList?
    var listItems: [String]
    var body: some View{
        NavigationLink(destination: SingleChoiceListView(vm: SingleChoiceListVM(PList: plist,
                                                                                listItems: listItems,
                                                                                singleChoiceString: query.selected,
                                                                                title: .oneCategory)),
                       tag: QueryType.category,
                       selection: $query.menuSelection) {EmptyView()}
    }
}
