//
//  MealDBVM_Tests.swift
//  Meal IdeasTests
//
//  Created by Steve Plavetzky on 3/21/22.
//

import XCTest
import Combine
@testable import Meal_Ideas

//Naming Structure: Test_UnitOfWork_StatueUnderTest_ExpectedBehavior
//Naming Structure: Text_[Struct or class]_[Variable or function]_[expected results]

//Testing Structure: Given, When, Then

class MealDBVM_Tests: XCTestCase {
    var sut: MealDBVM?
    var cancellables = Set<AnyCancellable>()
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MealDBVM(sourceCategory: .mealDBCategories, source: .mealDB)
        cancellables = []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancellables = []
    }

    @MainActor func test_MealDBVM_checkQuery_random(){
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

    
    @MainActor func test_MealDBVM_checkQuery_category_shouldReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Beef"
        let queryType: QueryType = .category
        //When
        sut.checkQuery(query: query, queryType: queryType){
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertGreaterThan(sut.meals.count, 0)
        //When using this filtered API call, it only brings back meal name and the thumbnail, so we can't verify if it has the ingredient or category
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_category_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .category
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.checkQuery(query: query, queryType: queryType){
//            expectation.fulfill()
        }
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertEqual(sut.meals.count, 0)
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_ingredient_shouldReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Apples"
        let queryType: QueryType = .ingredient
        //When
        sut.checkQuery(query: query, queryType: queryType){
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertGreaterThan(sut.meals.count, 0)
        //When using this filtered API call, it only brings back meal name and the thumbnail, so we can't verify if it has the ingredient or category
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_ingredient_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .ingredient
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.checkQuery(query: query, queryType: queryType){
//            expectation.fulfill()
        }
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertEqual(sut.meals.count, 0)
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_keyword_shouldReturnMeals(){
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
            XCTAssertTrue(((meal.strMeal?.containsIgnoringCase(find: query)) != nil))
        }
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_keyword_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .keyword
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.checkQuery(query: query, queryType: queryType){
//            expectation.fulfill()
        }
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertEqual(sut.meals.count, 0)
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
    
    
    @MainActor func test_MealDBVM_customFilter_noneProvided_shouldNotReturnMeals(){
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
    
    
    @MainActor func test_MealDBVM_customFilter_allInvalid_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = UUID().uuidString
        let category = UUID().uuidString
        let ingredient = UUID().uuidString
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
    
    
    @MainActor func test_MealDBVM_customFilter_allProvided_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = "Beef"
        let category = "Beef"
        let ingredient = "Bacon"
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.strMeal?.containsIgnoringCase(find: keyword)) != nil))
            //When using this filtered API call, it only brings back meal name and the thumbnail, so we can't verify if it has the ingredient or category
        }
    }
    
    
    @MainActor func test_MealDBVM_customFilter_keyword_shouldReturnMeals(){
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
            XCTAssertTrue(((meal.strMeal?.containsIgnoringCase(find: keyword)) != nil))
        }
    }
    
    
    @MainActor func test_MealDBVM_customFilter_keyword_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = UUID().uuidString
        let category = ""
        let ingredient = ""
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
    
    
    @MainActor func test_MealDBVM_customFilter_category_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = "Beef"
        let ingredient = ""
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        //When using this filtered API call, it only brings back meal name and the thumbnail, so we can't verify if it has the ingredient or category
    }
    
    
    @MainActor func test_MealDBVM_customFilter_category_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = UUID().uuidString
        let ingredient = ""
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        //When using this filtered API call, it only brings back meal name and the thumbnail, so we can't verify if it has the ingredient or category
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
    
    
    @MainActor func test_MealDBVM_customFilter_ingredient_shouldReturnMeals(){
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
        //When using this filtered API call, it only brings back meal name and the thumbnail, so we can't verify if it has the ingredient or category
    }
    
    
    @MainActor func test_MealDBVM_customFilter_ingredient_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = ""
        let ingredient = UUID().uuidString
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        //When using this filtered API call, it only brings back meal name and the thumbnail, so we can't verify if it has the ingredient or category
        XCTAssertEqual(sut.alertItem, expectedAlertItem)

    }
    
    
    @MainActor func test_MealDBVM_customFilter_keywordAndCategory_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = "Beef"
        let category = "Beef"
        let ingredient = ""
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.strMeal?.containsIgnoringCase(find: keyword)) != nil))
        }
    }
    
    
    @MainActor func test_MealDBVM_customFilter_keywordAndCategory_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = UUID().uuidString
        let category = UUID().uuidString
        let ingredient = ""
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
    
    
    @MainActor func test_MealDBVM_customFilter_categoryAndIngredient_shouldReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = "Beef"
        let ingredient = "Bacon"
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.strMeal?.containsIgnoringCase(find: keyword)) != nil))
        }
    }
    
    
    @MainActor func test_MealDBVM_customFilter_categoryAndIngredient_shouldNotReturnMeals(){
        //given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = UUID().uuidString
        let ingredient = UUID().uuidString
        let expectedAlertItem = AlertContext.invalidData
        //When
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient) {
            expectation.fulfill()
        }
        //Then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(sut.meals.count, 0)
        XCTAssertEqual(sut.alertItem, expectedAlertItem)
    }
}
