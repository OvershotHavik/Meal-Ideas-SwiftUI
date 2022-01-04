//
//  MealDBFunctions.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/11/21.
//

import Foundation
/*
ingredient:
 
 case .ingredients:
     let safeIngredient = item.replacingOccurrences(of: " ", with: "_")
     let url = URL(string: "https://www.themealdb.com/api/json/v2/9973533/filter.php?i=\(safeIngredient)")!
     print(url)
     ingredient = item
 
extension HomeVC {
    //MARK: - Fetch MealDB Categories
    func fetchMealDBCat(){
        print("Fetching MealDB cat \(category ?? "No category selected")")
        if let safeCategory = category{
            var modified = safeCategory.replacingOccurrences(of: " ", with: "%20")
            if modified == "Side%20Dish"{
                modified = "Side"
            }
            let url = URL(string: "https://www.themealdb.com/api/json/v2/9973533/filter.php?c=\(modified)")!
            print(url)
            mealDBMultiMeals(url: url, ID: .category)
        }
    }
    //MARK: - MealDB Multi Meals
    func mealDBMultiMeals(url: URL, ID: ID){
        DataManager.fetchData(url: url) { Result in
            switch Result{
            case .success(let data):
                do {
                    let meal = try JSONDecoder().decode(MealDBMultiMeal.Results.self, from: data)
                    for i in meal.meals{
                        self.additionalMealDBMeals.append(i)
                    }
                    self.showAdditionalMeals(source: .mealDB, ID: ID)
                } catch let e{
                    self.rootView.showNoMealsFound(source: .mealDB, ID: ID)
                    print(e)
                    return
                }
            case .failure(let e):
                print("Error at multiple meals meal db: \(e)")
            }
        }
    }
    //MARK: - MealDB Keyword
    func mealDBKeyword(keyword: String){
        print("Fetching MealDB Single Named Meal: \(keyword)")
        let modifiedKeyword = keyword.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://www.themealdb.com/api/json/v2/9973533/search.php?s=\(modifiedKeyword)")!
        print(url)
        mealDBMultiMeals(url: url, ID: .keyword)
    }
    //MARK: - Fetch MealDB Single Meal
    func fetchMealDBSingleNamedMeal(idMeal: String){
        print("Fetching MealDB Single Named iDMeal: \(idMeal)")
        let url = URL(string: "https://www.themealdb.com/api/json/v2/9973533/lookup.php?i=\(idMeal)")!

        print(url)
        MealDBNetworkCall.getSingleMeal(url: url) {Result in
            switch Result{
            case .success(let dict):
                DispatchQueue.main.async {
                    print("success in mealdb network Call")
                    for meals in dict{
                        if let safeIDMeal = meals.value.idMeal{
                            if (self.mealDBFavorites[safeIDMeal]) != nil{ // favorited
                                var favoritedMeal = meals.value
                                favoritedMeal.favorited = true
                                let mealVC = MealVC(mealDBMeal: favoritedMeal, spoonMeal: nil, userMeal: nil, showingHistory: false, favorited: true)
                                mealVC.addToHistoryDelegate = self
                                self.navigationController?.pushViewController(mealVC, animated: true)
                            }else { // not favorited
                                let mealVC = MealVC(mealDBMeal: meals.value, spoonMeal: nil, userMeal: nil, showingHistory: false, favorited: false)
                                self.navigationController?.pushViewController(mealVC, animated: true)
                            }
                        }
                        print("Meal : \(meals.value.strMeal ?? "")")
                    }
                }
            case .failure(let e):
                print("error in mealdb: \(e)")
            }
        }
    }
    //MARK: - MealDBRandom
    func fetchMealDBRandom(){
        rootView.addMealDBSpinner()
        print("Fetching MealDB Random")
        let url = URL(string: "https://www.themealdb.com/api/json/v2/9973533/randomselection.php")!
        print(url)
        DataManager.fetchData(url: url) { Result in
            switch Result{
            case .success(let data):
                do {
                    let meal = try JSONDecoder().decode(MealDBMultiMeal.Results.self, from: data)
                    for i in meal.meals{
                        self.additionalMealDBMeals.append(i)
                    }
                    self.rootView.updateMealDBResults(meals: self.additionalMealDBMeals, ID: .random)
                    self.additionalMealDBMeals = []
                    self.rootView.showAdditionalMeals(source: Source.mealDB, ID: .random)
                } catch let e{
                    self.rootView.showNoMealsFound(source: .mealDB, ID: .random)
                    print(e)
                    return
                }
            case .failure(let e):
                print("Error at multiple meals meal db: \(e)")
            }
        }
    }
}
*/
/*
static func getSingleMeal(url: URL, completionHandler: @escaping (Result<Dictionary<String,MealDBResults.Meal>, NetworkError>) -> Void){
    var tempMeal = [String: MealDBResults.Meal] ()
    DataManager.fetchData(url: url)  {Result in
        let decoder = JSONDecoder()
        switch Result{
        case .success(let data):
            do{
                print("in mealdb single meal")
                let meal = try decoder.decode(MealDBResults.Results.self, from: data)
                for i in meal.meals{
                    if let safeMeal = i.idMeal{
                        tempMeal[safeMeal] = i
                        completionHandler(.success(tempMeal))
                    }
                }
                print("---------- Done adding meals to dictionary")
            }catch {
                print("inside catch block in mealDB, potential bad data string: ")
                if let JSONString = String(data: data, encoding: String.Encoding.utf8){
                    print(JSONString)
                }
                print(error.localizedDescription)
                print(error)
                throw NetworkError.badData(data)
            }
        case .failure(let error):
            print(error.localizedDescription)
            throw NetworkError.failure(error)
        }
    }
}
*/
