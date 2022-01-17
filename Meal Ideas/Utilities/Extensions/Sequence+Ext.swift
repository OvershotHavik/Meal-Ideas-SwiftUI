//
//  Sequence+Ext.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/13/22.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return filter { seen.insert($0).inserted }
}
}
