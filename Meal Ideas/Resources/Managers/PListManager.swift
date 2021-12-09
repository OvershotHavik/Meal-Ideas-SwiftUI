//
//  PListManager.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/9/21.
//

import UIKit


final class PListManager{
    
    
    //MARK: - Items From User Plist Generic
    static  func loadItemsFromUserPlist<T>(userPlist: PList, classToDecodeTo: T.Type, completionHandler: @escaping (Result <Dictionary<String,T>, Error>) -> Void) where T: Decodable{
        print("In item from user mPlist")
        var userPlistData = Data()
        // Local plist stored in xcode
        var plistURL: URL {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documents.appendingPathComponent("\(userPlist).plist")
        }
        print("Plist url: \(plistURL)")
        if let data = try? Data.init(contentsOf: plistURL){
            userPlistData = data
        }
        do {
            let dictOfItemsFromLocalPlist = try PropertyListDecoder().decode([String:T].self, from: userPlistData)
            completionHandler(.success(dictOfItemsFromLocalPlist))
        } catch {
            print("error after do block: \(error)")
            completionHandler(.failure(error))
        }
    }
  
    //MARK: - Items from xCode plist generic
    static func loadItemsFromLocalPlist<T>(XcodePlist: PList, classToDecodeTo: [T].Type, completionHandler: @escaping (Result <Array<T>, Error>) -> Void) where T: Decodable {
        print("In item From local Plist")
        var xcodePlistData = Data()
        // Local plist stored in xcode
        if let path = Bundle.main.path(forResource: XcodePlist.rawValue, ofType: "plist"),
            let data = FileManager.default.contents(atPath: path){
            xcodePlistData = data
            print("xcode plist data: \(xcodePlistData)")
        }
        do {
            let arrayOfItemsFromLocalPlist = try PropertyListDecoder().decode(classToDecodeTo.self, from: xcodePlistData)
            completionHandler(.success(arrayOfItemsFromLocalPlist ))
        } catch {
            print("error after do block: \(error)")
            completionHandler(.failure(error))
        }
    }
     
    //MARK: - Copy from  plist and return the dictionary generic
    static func copyFromPlist<T>(plist: PList, classToDecodeTo: T.Type, completionHandler: @escaping (Result <Dictionary<String,T>, Error>) -> Void) where T: Codable{
        var plistURL: URL {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documents.appendingPathComponent("\(plist).plist")
        }
        print("Plist url: \(plistURL)")
        guard let data = try? Data.init(contentsOf: plistURL) else { return }
        do {
            let tempDict = try PropertyListDecoder().decode([String:T].self, from: data)
            completionHandler(.success(tempDict))
        } catch let e{
            print(e)
            completionHandler(.failure(e))
        }
    }
    
    //MARK: - Update Plist
    static func updatePlist<T>(plist: PList, dictWithUpdates: Dictionary<String,T>) where T: Codable{
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(plist).plist")
        do{
            let plistData = try encoder.encode(dictWithUpdates)
            try plistData.write(to: path)
            print("successfully updated \(plist)")
        } catch let e{
            print(e)
        }
    }
    
    //MARK: - Update History Plist
    static func updateHistoryPlist<T>(plist: PList, dictWithUpdates: Dictionary<Date,T>) where T: Codable{
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(plist).plist")
        do{
            let plistData = try encoder.encode(dictWithUpdates)
            try plistData.write(to: path)
            print("successfully updated \(plist)")
        } catch let e{
            print(e)
        }
    }
 
    //MARK: - Load MealDB Favorites
    static func loadMealDBFavorites(completionHandler: @escaping (Result <Dictionary <String, Favorites>, Error>) -> Void){
        PListManager.copyFromPlist(plist: .mealDBFavorites, classToDecodeTo: Favorites.self) { result in
                switch result{
                case .success(let dict):
                    var mealDBDict: [String: Favorites] = [:]
                    for meal in dict{
                        if let safeMealID = meal.value.mealDBID{
                            mealDBDict[safeMealID] = meal.value
                        }
                    }
                    print("MealDB Favorites Count: \(mealDBDict.count)")
                    completionHandler(.success(mealDBDict))
                case .failure(let e): print("error getting mealDB Favorites: \(e)")
                }
        }
    }
    //MARK: - Load Spoon Favorites
    static func loadSpoonFavorites(completionHandler: @escaping (Result <Dictionary <String, Favorites>, Error>) -> Void){
        PListManager.copyFromPlist(plist: .spoonFavorites, classToDecodeTo: Favorites.self) { result in
                switch result{
                case .success(let dict):
                    var spoonFavorites : [String: Favorites] = [:]
                    for meal in dict {
                        if let safeSpoonID = meal.value.spoonID{
                            spoonFavorites["\(safeSpoonID)"] = meal.value
                        }
                    }
                    print("Spoon favorites Count: \(spoonFavorites.count)")
                    completionHandler(.success(spoonFavorites))
                case .failure(let e): print("error getting spoon favorites: \(e)")
                }
        }
    }
    
    static func addToFavorites(meal: String, source: Source, mealDBID: String?, spoonID: Int?){
        let newFavorite = Favorites()
        newFavorite.mealName = meal
        switch source{
        case .mealDB:
            var mealDBFavorites: [String: Favorites] = [:]
            if let safeMealDBID = mealDBID{
                newFavorite.mealDBID = safeMealDBID
            }
            //Check to see if the plist exists. If it does, write to it, if not create a new one via update
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
             let url = NSURL(fileURLWithPath: path)
             if let pathComponent = url.appendingPathComponent("\(PList.mealDBFavorites).plist") {
                 let filePath = pathComponent.path
                 let fileManager = FileManager.default
                 if fileManager.fileExists(atPath: filePath) {
                     print("FILE AVAILABLE - load file and add to it ")
                     PListManager.loadMealDBFavorites(completionHandler: { result in
                        switch result{
                        case .success(let dict):
                            mealDBFavorites = dict
                            if let safeMealDBID = mealDBID{
                                mealDBFavorites[safeMealDBID] = newFavorite
                                PListManager.updatePlist(plist: .mealDBFavorites, dictWithUpdates: mealDBFavorites)
                                print("Added \(meal) to MealDB favorites")
                            }
                        case .failure(let e): print("Error getting mealdb favorites: \(e)")
                        }
                    })
                 } else {
                     print("FILE NOT AVAILABLE - file needs to be created first")
                    
                    if let safeMealDBID = mealDBID{
                        mealDBFavorites[safeMealDBID] = newFavorite
                        PListManager.updatePlist(plist: .mealDBFavorites, dictWithUpdates: mealDBFavorites)
                        print("Created new mealDB Favorites plist")
                    }
                 }
             } else {
                 print("FILE PATH NOT AVAILABLE")
             }
            
        case .spoonacular:
            var spoonFavorites : [String: Favorites] = [:]
            if let safeSpoonID = spoonID{
                newFavorite.spoonID = safeSpoonID
            }
            //Check to see if the plist exists. If it does, write to it, if not create a new one via update
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
             let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("\(PList.spoonFavorites).plist") {
                 let filePath = pathComponent.path
                 let fileManager = FileManager.default
                 if fileManager.fileExists(atPath: filePath) {
                     print("FILE AVAILABLE")
                     PListManager.loadSpoonFavorites(completionHandler: { result in
                        switch result{
                        case .success(let dict):
                            spoonFavorites = dict
                            if let safeSpoonID = spoonID{
                                spoonFavorites["\(safeSpoonID)"] = newFavorite
                                PListManager.updatePlist(plist: .spoonFavorites, dictWithUpdates: spoonFavorites)
                                print("Added \(meal) to Spoon favorites")
                            }
                        case .failure(let e): print("Error getting spoon favorites: \(e)")
                        }
                    })
                 } else {
                     print("FILE NOT AVAILABLE")
                    if let safeSpoonID = spoonID{
                        spoonFavorites["\(safeSpoonID)"] = newFavorite
                        PListManager.updatePlist(plist: .spoonFavorites, dictWithUpdates: spoonFavorites)
                        print("created new Spoon favorites plist")
                    }
                 }
             } else {
                 print("FILE PATH NOT AVAILABLE")
             }

        }
    }
    
    //MARK: - Remove From Favorites
    static func removeFavorite(meal: String, source: Source, mealDBID: String?, spoonID: Int?){
        let favoriteToRemove = Favorites()
        favoriteToRemove.mealName = meal
        
        switch source{
        case .mealDB:
            var mealDBFavorites: [String: Favorites] = [:]

            PListManager.loadMealDBFavorites(completionHandler: { result in
                switch result{
                case .success(let dict):
                    mealDBFavorites = dict
                    if let safeMealDBID = mealDBID{
                        favoriteToRemove.mealDBID = safeMealDBID
                        mealDBFavorites[safeMealDBID] = nil
                        PListManager.updatePlist(plist: .mealDBFavorites, dictWithUpdates: mealDBFavorites)
                        print("removed \(meal) from MealDB favorites")
                    }
                case .failure(let e): print("Error getting mealdb favorites: \(e)")
                }
            })


        case .spoonacular:
            var spoonFavorites : [String: Favorites] = [:]

            PListManager.loadMealDBFavorites(completionHandler: { result in
                switch result{
                case .success(let dict):
                    spoonFavorites = dict
                    if let safeSpoonID = spoonID{
                        favoriteToRemove.spoonID = safeSpoonID
                        spoonFavorites["\(safeSpoonID)"] = nil
                        PListManager.updatePlist(plist: .spoonFavorites, dictWithUpdates: spoonFavorites)
                        print("removed \(meal) from Spoon favorites")
                    }
                case .failure(let e): print("Error getting spoon favorites: \(e)")
                }
            })
        }
    }
}
