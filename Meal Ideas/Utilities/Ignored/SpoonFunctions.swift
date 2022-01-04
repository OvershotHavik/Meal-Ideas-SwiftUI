//
//  SpoonFunctions.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/11/21.
//

import Foundation
/*

//MARK: - Spoonacular
extension HomeVC{
    //MARK: - Spoon Random
    func spoonRandom(){
        rootView.addSpoonSpinner()
        let url = URL(string: "https://api.spoonacular.com/recipes/random?number=10&apiKey=b43f993c0e1f412cbce883f64c0bca69")!
        print(url)
        spoonNetworkCall(url: url, ID: .random)
    }
    //MARK: - Spoon Network Call
    func  spoonNetworkCall(url: URL, ID: ID){
        SpoonacularNetworkCall.getSpoonMeals(url: url) { Result in
            switch Result{
            case .success(let dict):
                print("success in spoon \(dict.keys)")
                if dict.count == 0{
                    DispatchQueue.main.async {
                        self.rootView.showNoMealsFound(source: .spoonacular, ID: ID)
                        print("No meals found in spoon network call for ID: \(ID)")
                        return
                    }
                } else {
                    self.rootView.updateSpoonMeals(meals: dict)
                    self.rootView.updateSpoonResults(ID: ID)
                    self.rootView.showAdditionalMeals(source: Source.spoonacular, ID: ID)
                }
            case .failure(let e):
                print("Error in spoon \(e)")
            }
        }
    }
    //MARK: - Spoon Category
    func spoonCategory(){
        if let safeCategory = category?.lowercased(){
            let modifiedSafeCategory = safeCategory.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=b43f993c0e1f412cbce883f64c0bca69&number=10&tags=\(modifiedSafeCategory)")!
            print(url)
            spoonNetworkCall(url: url, ID: .category)
        }
    }
    //MARK: - Spoon Ingredients
    func spoonIngredient(selectedIngredient: String){
        print("Ingredient Offset: \(String(describing: self.offsetBy))")
        print("ingredient: \(selectedIngredient)")
        let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=b43f993c0e1f412cbce883f64c0bca69&number=10&addRecipeInformation=true&offset=\(self.offsetBy)&includeIngredients=\(selectedIngredient)&fillIngredients=true")!
        print(url)
        self.spoonNetworkCall(url: url, ID: .ingredients)
        self.offsetBy += 10
    }
    //MARK: - Spoon Keyword
    func spoonKeyword(keyword: String){
        print("spoon keyword: \(String(describing: keyword))")
        var safeKeyword = keyword.lowercased()
        safeKeyword = safeKeyword.replacingOccurrences(of: " ", with: "%20")
        print(safeKeyword)
        print("keyword Offset: \(offsetBy)")
        let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=b43f993c0e1f412cbce883f64c0bca69&number=10&offset=\(self.offsetBy)&titleMatch=\(safeKeyword)")!
        
        print(url)
        self.offsetBy += 10
        DataManager.fetchData(url: url) { Result in
            switch Result{
            case .success(let data):
                do {
                    var spoonKeywordMeals: [String: SpoonacularKeywordResults.result] = [:]

                    let meals = try JSONDecoder().decode(SpoonacularKeywordResults.DataResult.self, from: data)
                    for i in meals.results{
                        spoonKeywordMeals["\(i.id)"] = i
                    }
                    if spoonKeywordMeals.count == 0{
                        DispatchQueue.main.async {
                            self.rootView.showNoMealsFound(source: .spoonacular, ID: .keyword)
                            print("No meals found in spoon network call for ID: Keyword")
                            return
                        }
                    } else {
                        self.rootView.updateSpoonMealsKeyword(meals: spoonKeywordMeals)
                        self.rootView.updateSpoonKeywordResults(ID: .keyword)
                        self.rootView.showAdditionalMeals(source: Source.spoonacular, ID: .keyword)
                    }
                } catch {
                    print("inside catch block in spoon keyword call")
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8){
                        print(JSONString)
                    }
                    print(error.localizedDescription)
                    print(error)
                    throw NetworkError.badData(data)
                }
            case .failure(let e): print("Error in keyword call: \(e)")
            }
        }
    }
}
*/
