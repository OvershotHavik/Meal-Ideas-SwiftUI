//
//  HistoryListVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/19/21.
//

import Foundation
import CoreData

final class HistoryListVM: ObservableObject{
    @Published var source: Source
    @Published var historyArray : [History] = []
    @Published var searchText = ""
    @Published var deleteASPresented = false
    var searchResults: [History] {
        if searchText.isEmpty {
            return historyArray
        } else {
            return historyArray.filter { $0.mealName!.contains(searchText) }
        }
    }
    
    init(source: Source){
        self.source = source
    }
    
    // MARK: - Filtered History by source
    func filteredHistory(history: [History]){
        switch source {
        case .spoonacular:
            let spoonHistory = history.filter{$0.spoonID != 0}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
            print("Spoon History Count: \(spoonHistory.count) ")
            historyArray = spoonHistory
        case .mealDB:
            let mealDBHistory = history.filter {$0.mealDBID != nil}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
            print("MealDB History Count: \(mealDBHistory.count)")
            historyArray = mealDBHistory
        case .myIdeas:
//            let myIdeasHistory = history.filter{$0.spoonID == 0 && $0.mealDBID == nil}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
            let myIdeasHistory = history.filter{$0.userMealID != nil}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
            print("My Ideas history count: \(myIdeasHistory.count)")
            historyArray = myIdeasHistory
        }
    }
    // MARK: - Fetch User Meal
    func fetchUserMeal(userMealID: UUID?) -> UserMeals?{
        if let safeID = userMealID{
            let request = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
            var allMeals: [UserMeals] = []
            
            do {
                allMeals = try PersistenceController.shared.container.viewContext.fetch(request)
//                print("Meals Fetched in Fetch Favorite")
            }catch let e{
                print("error fetching meal in fetch Favorites: \(e.localizedDescription)")
            }
            for meal in allMeals{
                if meal.userMealID == safeID{
                    print("Safe meal name: \(safeID)")
                    return meal
                }
            }
        }
        return nil
    }
    
    // MARK: - Fetch Spoon Meal
    func fetchSpoonMeal(spoonID: Double) ->  SpoonacularResults.Recipe?{
        let mealIDInt: Int = Int(spoonID)
        print("Spoon meal ID: \(mealIDInt)")
        let mealID = "\(mealIDInt)"
//        isLoading = true
        Task { () -> SpoonacularResults.Recipe? in
            do {
                let meal = try await NetworkManager.shared.spoonSingleMeal(query: mealID)
                return meal
            } catch let e{
                print(e.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Fetch MealDB Meal
    func fetchMealDBMeal(mealDBID: String?) -> MealDBResults.Meal?{

        print("Fetching MealDB Single Named mealID: \(mealDBID ?? "")")
//        isLoading = false
        Task { () -> MealDBResults.Meal? in
            do {
                let results = try await NetworkManager.shared.mealDBQuery(query: mealDBID ?? "", queryType: .none)
                if let safeResults = results.first{
                    return safeResults
                }
            } catch let e{
                print("Error loading meal db favorite: \(e.localizedDescription)")
                return nil
            }
            return nil
        }
        return nil
    }
    
    // MARK: - Check For Favorite
    func checkForFavorite(favoritesArray: [Favorites], id: String?, userMealID: UUID?) -> Bool{
        switch source {
        case .spoonacular:
            if let safeDouble: Double = Double(id ?? ""){
                if favoritesArray.contains(where: {$0.spoonID == safeDouble}){
//                    print("favorited meal id: \(id ?? "")")
                    return true
                } else {
                    return false
                }
            }
        case .mealDB:
            if favoritesArray.contains(where: {$0.mealDBID == id}){
//                print("favorited meal id: \(id ?? "")")
                return true
            } else {
                return false
            }
        case .myIdeas:

            if favoritesArray.contains(where: {$0.userMealID == userMealID}){
                //                        print("Favorite meal id: \(safeUUID)")
                return true
                
            
                
//            if favoritesArray.contains(where: {$0.mealName == id}){
//                print("favorited meal id: \(id ?? "")")
//                return true
                
            } else {
                return false
            }
        }

        return false
    }
    

}
