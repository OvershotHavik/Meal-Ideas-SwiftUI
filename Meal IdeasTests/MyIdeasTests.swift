//
//  MyIdeasTests.swift
//  Meal IdeasTests
//
//  Created by Steve Plavetzky on 3/20/22.
//

import XCTest
@testable import Meal_Ideas
import Combine

//Naming Structure: Test_UnitOfWork_StatueUnderTest_ExpectedBehavior
//Naming Structure: Text_[Struct or class]_[Variable or function]_[expected results]

//Testing Structure: Given, When, Then

class MyIdeasTests: XCTestCase {
    var sut: MyIdeasVM? // system Under Test
    var cancellables = Set<AnyCancellable>()
/*
 Will need to create a meal, named "Test" with a category of "Snack" and an ingredient of "Apple" for the tests to work
 */
    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MyIdeasVM()
        cancellables = []
    }
    
    
    override func tearDownWithError() throws {
        try super.setUpWithError()
        sut = nil
        cancellables = []
    }
    
    
    @MainActor func test_MyIdeasVM_getAllMeals_shouldReturnMeals() {
        guard let sut = sut else {return}
        sut.getAllMeals()
        XCTAssertGreaterThan(sut.allMeals.count , 0, "Number of meals: \(sut.allMeals.count)")
    }
    
    
    @MainActor func test_MyIdeasVM_showAllMeals_shouldReturnMeals(){
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        sut.showAllMeals()
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 2)
        XCTAssertGreaterThan(sut.meals.count, 0)
    }
    
    
    @MainActor func test_MyIdeasVM_random_shouldReturnMeal(){
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Test"
        sut.checkQuery(query: query, queryType: .random)
        sut.$meals
//            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
        XCTAssertGreaterThan(sut.meals.count, 0)
    }
    
    
    @MainActor func test_MyIdeasVM_keyword_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Test"
        sut.checkQuery(query: query, queryType: .keyword)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.mealName?.containsIgnoringCase(find: query)) != nil))// verify the meals contain the query
        }
    }
    

    @MainActor func test_MyIdeasVM_keyword_shouldNotReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Test1"
        let queryType: QueryType = .keyword
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sut.meals.count, 0)
    }
    
    
    @MainActor func test_MyIdeasVM_category_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Snack"
        let queryType: QueryType = .category
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            if let categories = meal.category as? [String]{
                XCTAssertTrue(categories.contains(where: {$0 == query}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_category_shouldNotReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString // invalid
        let queryType: QueryType = .category
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(sut.meals.count == 0)
    }
    
    
    @MainActor func test_MyIdeasVM_ingredient_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Apples"
        let queryType: QueryType = .ingredient
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            if let ingredients = meal.ingredients as? [String]{
                XCTAssertTrue(ingredients.contains(where: {$0 == query}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_ingredient_shouldNotReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString // invalid
        let queryType: QueryType = .ingredient
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(sut.meals.count == 0)
    }
    
    
    @MainActor func test_MyIdeasVM_custom_allProvided_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = "Test"
        let category = "Snack"
        let ingredient = "Apples"
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.mealName?.containsIgnoringCase(find: keyword)) != nil))// verify the meal name contain the keyword
            if let categories = meal.category as? [String]{
                XCTAssertTrue(categories.contains(where: {$0 == category}))
            }
            if let ingredients = meal.ingredients as? [String]{
                XCTAssertTrue(ingredients.contains(where: {$0 == ingredient}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_custom_noneProvided_shouldNotReturnMeal(){
        guard let sut = sut  else {return}
        let keyword = ""
        let category = ""
        let ingredient = ""
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        //Nothing happens since nothing was provided

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(sut.meals.count == 0)
        }
    }
     
    
    @MainActor func test_MyIdeasVM_custom_keyword_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = "Test"
        let category = ""
        let ingredient = ""
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.mealName?.containsIgnoringCase(find: keyword)) != nil))// verify the meal name contain the keyword
        }
    }
    
    
    @MainActor func test_MyIdeasVM_custom_keyword_shouldNotReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = UUID().uuidString
        let category = ""
        let ingredient = ""
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(sut.meals.count == 0)
    }
    
    
    @MainActor func test_MyIdeasVM_custom_category_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = "Snack"
        let ingredient = ""
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            if let categories = meal.category as? [String]{
                XCTAssertTrue(categories.contains(where: {$0 == category}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_custom_category_shouldNotReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = UUID().uuidString
        let ingredient = ""
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(sut.meals.count == 0)
    }
    
    
    @MainActor func test_MyIdeasVM_custom_ingredient_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = ""
        let ingredient = "Apples"
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            if let ingredients = meal.ingredients as? [String]{
                XCTAssertTrue(ingredients.contains(where: {$0 == ingredient}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_custom_ingredient_shouldNotReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = ""
        let ingredient = UUID().uuidString
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(sut.meals.count == 0)
    }
    
    
    @MainActor func test_MyIdeasVM_custom_keywordAndCategory_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = "Test"
        let category = "Snack"
        let ingredient = ""
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.mealName?.containsIgnoringCase(find: keyword)) != nil))// verify the meal name contain the keyword
            if let categories = meal.category as? [String]{
                XCTAssertTrue(categories.contains(where: {$0 == category}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_custom_keywordAndIngredient_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = "Test"
        let category = ""
        let ingredient = "Apples"
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertTrue(((meal.mealName?.containsIgnoringCase(find: keyword)) != nil))// verify the meal name contain the keyword
            if let ingredients = meal.ingredients as? [String]{
                XCTAssertTrue(ingredients.contains(where: {$0 == ingredient}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_custom_categoryAndIngredient_shouldReturnMeal(){
        guard let sut = sut  else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let keyword = ""
        let category = "Snack"
        let ingredient = "Apples"
        sut.customFilter(keyword: keyword, category: category, ingredient: ingredient)
        sut.$meals
            .dropFirst() // drops the first initialized array that would be blank, not the values of the array
            .sink{returnedItems in
                  expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            if let categories = meal.category as? [String]{
                XCTAssertTrue(categories.contains(where: {$0 == category}))
            }
            if let ingredients = meal.ingredients as? [String]{
                XCTAssertTrue(ingredients.contains(where: {$0 == ingredient}))
            }
        }
    }
}
