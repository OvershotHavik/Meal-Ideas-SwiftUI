//
//  PListManager.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import UIKit


final class PListManager{
  
    static func loadItemsFromLocalPlist<T>(XcodePlist: PList, classToDecodeTo: [T].Type, completionHandler: @escaping (Result <Array<T>, Error>) -> Void) where T: Decodable {
        var xcodePlistData = Data()
        // Local plist stored in xcode
        if let path = Bundle.main.path(forResource: XcodePlist.rawValue, ofType: "plist"),
            let data = FileManager.default.contents(atPath: path){
            xcodePlistData = data
        }
        do {
            let arrayOfItemsFromLocalPlist = try PropertyListDecoder().decode(classToDecodeTo.self, from: xcodePlistData)
            completionHandler(.success(arrayOfItemsFromLocalPlist ))
        } catch {
            print("error after do block: \(error)")
            completionHandler(.failure(error))
        }
    }
}
