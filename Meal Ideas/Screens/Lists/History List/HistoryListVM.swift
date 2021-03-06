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
            return historyArray.filter { $0.mealName!.containsIgnoringCase(find: searchText) }
        }
    }
    
    init(source: Source){
        self.source = source
    }
    

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
            let myIdeasHistory = history.filter{$0.userMealID != nil}.sorted{$0.timeStamp ?? Date() > $1.timeStamp ?? Date()}
            print("My Ideas history count: \(myIdeasHistory.count)")
            historyArray = myIdeasHistory
        }
    }


    func fetchUserMeal(userMealID: UUID?) -> UserMeals?{
        if let safeID = userMealID{
            let request = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
            var allMeals: [UserMeals] = []
            
            do {
                allMeals = try PersistenceController.shared.container.viewContext.fetch(request)
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
    

    func fetchSpoonMeal(spoonID: Double) ->  SpoonacularResults.Recipe?{
        let mealIDInt: Int = Int(spoonID)
        print("Spoon meal ID: \(mealIDInt)")
        let mealID = "\(mealIDInt)"
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
    

    func fetchMealDBMeal(mealDBID: String?) -> MealDBResults.Meal?{
        print("Fetching MealDB Single Named mealID: \(mealDBID ?? "")")
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
    

    func checkForFavorite(favoritesArray: [Favorites], id: String?, userMealID: UUID?) -> Bool{
        switch source {
        case .spoonacular:
            if let safeDouble: Double = Double(id ?? ""){
                if favoritesArray.contains(where: {$0.spoonID == safeDouble}){
                    return true
                } else {
                    return false
                }
            }
            
            
        case .mealDB:
            if favoritesArray.contains(where: {$0.mealDBID == id}){
                return true
            } else {
                return false
            }
            
            
        case .myIdeas:
            if favoritesArray.contains(where: {$0.userMealID == userMealID}){
                return true
            } else {
                return false
            }
        }
        return false
    }
}
