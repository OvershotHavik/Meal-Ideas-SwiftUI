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
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
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
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertGreaterThan(sut.meals.count, 0)
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_category_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .category
        //When
        sut.checkQuery(query: query, queryType: queryType)
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
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_ingredient_shouldReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Apples"
        let queryType: QueryType = .ingredient
        //When
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertGreaterThan(sut.meals.count, 0)
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_ingredient_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .ingredient
        //When
        sut.checkQuery(query: query, queryType: queryType)
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
    }
    
    @MainActor func test_MealDBVM_checkQuery_keyword_shouldReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = "Cheese"
        let queryType: QueryType = .keyword
        //When
        sut.checkQuery(query: query, queryType: queryType)
        sut.$meals
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        //Then
        wait(for: [expectation], timeout: 10)
        print("Number of meals: \(sut.meals.count)")
        XCTAssertGreaterThan(sut.meals.count, 0)
    }
    
    
    @MainActor func test_MealDBVM_checkQuery_keyword_shouldNotReturnMeals(){
        //Given
        guard let sut = sut else {return}
        let expectation = expectation(description: "Wait for meals to populate")
        let query = UUID().uuidString
        let queryType: QueryType = .keyword
        //When
        sut.checkQuery(query: query, queryType: queryType)
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
    }
}
