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
    
    
    @MainActor func test_MyIdeasVM_GetAllMeals_shouldReturnMeals() {
        guard let sut = sut else {return}
        sut.getAllMeals()
        XCTAssertGreaterThan(sut.allMeals.count , 0, "Number of meals: \(sut.allMeals.count)")
    }
    
    
    @MainActor func test_MyIdeasVM_Keyword_shouldReturnMeal(){
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

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            XCTAssertEqual(meal.mealName, query) // verify the meals returned have the query
        }
    }
    

    @MainActor func test_MyIdeasVM_Keyword_shouldNotReturnMeal(){
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

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(sut.meals.count, 0)
    }
    
    
    @MainActor func test_MyIdeasVM_Category_shouldReturnMeal(){
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

        wait(for: [expectation], timeout: 10)
        XCTAssertGreaterThan(sut.meals.count, 0)
        for meal in sut.meals{
            if let categories = meal.category as? [String]{
                XCTAssertTrue(categories.contains(where: {$0 == query}))
            }
        }
    }
    
    
    @MainActor func test_MyIdeasVM_Category_shouldNotReturnMeal(){
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
    
    
    @MainActor func test_MyIdeasVM_Ingredient_shouldReturnMeal(){
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
    
    
    @MainActor func test_MyIdeasVM_Ingredient_shouldNotReturnMeal(){
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
    
    
}
