//
//  CustomFilterVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/24/22.
//

import Foundation

@MainActor final class CustomFilterVM: ObservableObject{
    @Published var source: Source
    @Published var name: String = ""
    @Published var plist: PList?
    @Published var category: String = ""
    @Published var ingredient: String = ""
    @Published var listItems: [String]
    
    init(source: Source, plist: PList?, listItems: [String]){
        self.source = source
        self.plist = plist
        self.listItems = listItems
    }
}
