//
//  SpoonVM_Tests.swift
//  Meal IdeasTests
//
//  Created by Steve Plavetzky on 3/22/22.
//

import XCTest
import Combine
@testable import Meal_Ideas
//Naming Structure: Test_UnitOfWork_StatueUnderTest_ExpectedBehavior
//Naming Structure: Text_[Struct or class]_[Variable or function]_[expected results]

//Testing Structure: Given, When, Then

class SpoonVM_Tests: XCTestCase {

    var sut: SpoonVM?
    var cancellables = Set<AnyCancellable>()
    var sourceCategories: [String] = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SpoonVM(sourceCategory: .spoonCategories, source: .spoonacular)
        cancellables = []
        fetchPlist(plist: .spoonCategories)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancellables = []
        sourceCategories = []
    }
    //To get the category verification part for spoon since if this is not run, spoon will bring back random results
    func fetchPlist(plist: PList){
        if sourceCategories.isEmpty{
            PListManager.loadItemsFromLocalPlist(XcodePlist: plist,
                                                 classToDecodeTo: [NewItem].self,
                                                 completionHandler: { [weak self] result in
                if let self = self {
                    switch result {
                    case .success(let itemArray):
                        self.sourceCategories = itemArray.map{$0.itemName}
                    case .failure(let e): print(e)
                    }
                }
            })
        }
    }
    
    @MainActor func test_SpoonVM_checkQuery_random(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = ""
        let queryType: QueryType = .random
        //When
        sut.checkQuery(query: query, queryType: queryType){
            expectation.fulfill()
        }
//        sut.$meals
//            .dropFirst()
//            .sink { _ in
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
        //then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
    }
    
    
    @MainActor func test_SpoonVM_checkQuery_category_shouldReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let query = "Appetizer"
        let queryType: QueryType = .category
        //When
        
        if sourceCategories.contains(query){
            let expectation = expectation(description: "Wait for meals to populate")
            sut.checkQuery(query: query, queryType: queryType){
                expectation.fulfill()
            }
            //Then
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(((meal.dishTypes?.contains(query)) != nil))
            }
        } else {
            //Then
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
    
    
    @MainActor func test_SpoonVM_checkQuery_category_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let query = UUID().uuidString
        let queryType: QueryType = .category
        //When
        if sourceCategories.contains(query){
            XCTFail() // shouldn't hit
            let expectation = expectation(description: "Wait for meals to populate")
            sut.checkQuery(query: query, queryType: queryType){
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertEqual(sut.meals.count, 0)
        } else {
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
    
    
    @MainActor func test_SpoonVM_checkQuery_ingredient_shouldReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Almonds"
        let queryType: QueryType = .ingredient
        //When
        sut.checkQuery(query: query, queryType: queryType){
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            let ingredients = meal.extendedIngredients.compactMap({$0.name})
            XCTAssertTrue(ingredients.contains(where: {$0.containsIgnoringCase(find: query)}))
        }
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_ingredient_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .ingredient
        //When
        sut.checkQuery(query: query, queryType: queryType){
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertEqual(sut.meals.count, 0)
        //No errors thrown, the server responds but with a blank array of meals, which is being checked above
    }
    
    
    @MainActor func test_SpoonVM_checkQuery_keyword_shouldReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Cheese"
        let queryType: QueryType = .keyword
        //When
        sut.checkQuery(query: query, queryType: queryType){
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(meal.title.containsIgnoringCase(find: query))
        }
    }
    
    
    @MainActor func test_SpoonVM_checkQuery_keyword_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .keyword
        //When
        sut.checkQuery(query: query, queryType: queryType){
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertEqual(sut.meals.count, 0)
        //No errors thrown, the server responds but with a blank array of meals, which is being checked above
    }
    
    
    @MainActor func test_SpoonVM_customFilter_noneProvided_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = ""
        let ingredient = ""
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        //No errors thrown since the
    }
    
    
    @MainActor func test_SpoonVM_customFilter_allInvalid_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = UUID().uuidString
        let category = UUID().uuidString
        let ingredient = UUID().uuidString
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        //No errors thrown, the server responds but with a blank array of meals, which is being checked above
    }
    
    
    @MainActor func test_SpoonVM_customFilter_allProvided_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let keyword = "Cookie"
        let category = "Dessert"
        let ingredient = "Banana"
        //When
        if sourceCategories.contains(category){
            let expectation = expectation(description: "Wait for meals to populate")
            sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(meal.title.containsIgnoringCase(find: keyword))
                let ingredients = meal.extendedIngredients.compactMap({$0.name})
                XCTAssertTrue(ingredients.contains(where: {$0.containsIgnoringCase(find: ingredient)}))
            }
        } else {
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
    
    @MainActor func test_SpoonVM_customFilter_keyword_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = "Beef"
        let category = ""
        let ingredient = ""
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(meal.title.containsIgnoringCase(find: keyword))
        }
    }
    
    
    @MainActor func test_SpoonVM_customFilter_keyword_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = UUID().uuidString
        let category = ""
        let ingredient = ""
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
    }
    
    
    @MainActor func test_SpoonVM_customFilter_category_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let keyword = ""
        let category = "Dessert"
        let ingredient = ""
        //When
        
        if sourceCategories.contains(category){
            let expectation = expectation(description: "Wait for meals to populate")
            sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
                expectation.fulfill()
            }
            //Then
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(((meal.dishTypes?.contains(category)) != nil))
            }
        } else {
            //Then
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
        //Then
    }
    
    
    @MainActor func test_SpoonVM_customFilter_category_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let keyword = ""
        let category = UUID().uuidString
        let ingredient = ""
        //When
        if sourceCategories.contains(category){
            XCTFail() // shouldn't hit
            let expectation = expectation(description: "Wait for meals to populate")
            sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
                expectation.fulfill()
            }
            //Then
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(((meal.dishTypes?.contains(category)) != nil))
            }
        } else {
            //Then
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
    
    
    @MainActor func test_SpoonVM_customFilter_ingredient_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = ""
        let ingredient = "Bacon"
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            let ingredients = meal.extendedIngredients.compactMap({$0.name})
            XCTAssertTrue(ingredients.contains(where: {$0.containsIgnoringCase(find: ingredient)}))
        }

    }
    
    
    @MainActor func test_SpoonVM_customFilter_ingredient_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = ""
        let ingredient = UUID().uuidString
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
    }
    
    
    @MainActor func test_SpoonVM_customFilter_keywordAndCategory_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let keyword = "Cookie"
        let category = "Dessert"
        let ingredient = ""
        //When
        if sourceCategories.contains(category){
            let expectation = expectation(description: "Wait for meals to populate")
            sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
                expectation.fulfill()
            }
            //Then
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(meal.title.containsIgnoringCase(find: keyword))
                XCTAssertTrue(((meal.dishTypes?.contains(category)) != nil))
            }
        } else {
            //Then
            XCTFail()
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
    
    
    @MainActor func test_SpoonVM_customFilter_keywordAndCategory_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let keyword = UUID().uuidString
        let category = UUID().uuidString
        let ingredient = ""
        //When
        if sourceCategories.contains(category){
            XCTFail() // shouldn't hit
            let expectation = expectation(description: "Wait for meals to populate")
            sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
                expectation.fulfill()
            }
            //Then
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(meal.title.containsIgnoringCase(find: keyword))
                XCTAssertTrue(((meal.dishTypes?.contains(category)) != nil))
            }
        } else {
            //Then
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
    
    
    @MainActor func test_SpoonVM_customFilter_categoryAndIngredient_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let keyword = ""
        let category = "Dessert"
        let ingredient = "Banana"
        //When
        if sourceCategories.contains(category){
            let expectation = expectation(description: "Wait for meals to populate")
            sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
                expectation.fulfill()
            }
            //Then
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(((meal.dishTypes?.contains(category)) != nil))
                let ingredients = meal.extendedIngredients.compactMap({$0.name})
                XCTAssertTrue(ingredients.contains(where: {$0.containsIgnoringCase(find: ingredient)}))
            }
        } else {
            //Then
            XCTFail()
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
    
    
    @MainActor func test_SpoonVM_customFilter_categoryAndIngredient_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let keyword = ""
        let category = UUID().uuidString
        let ingredient = UUID().uuidString
        //When
        if sourceCategories.contains(category){
            XCTFail() // shouldn't hit
            let expectation = expectation(description: "Wait for meals to populate")
            sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
                expectation.fulfill()
            }
            //Then
            wait(for: [expectation], timeout: 10)
            print("Number of meals: \(sut.meals.count)")
            XCTAssertGreaterThan(sut.meals.count, 0)
            for meal in sut.meals{
                XCTAssertTrue(((meal.dishTypes?.contains(category)) != nil))
                let ingredients = meal.extendedIngredients.compactMap({$0.name})
                XCTAssertTrue(ingredients.contains(where: {$0.containsIgnoringCase(find: ingredient)}))
            }
        } else {
            //Then
            //Invalid category, which would cause the API to return random results
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
}
