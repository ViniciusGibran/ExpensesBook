//
//  ExpenseModelTests.swift
//  ExpensesBookTests
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import XCTest
import RealmSwift
@testable import ExpensesBook

import XCTest
import RealmSwift
@testable import ExpensesBook

final class ExpenseModelDTOTests: XCTestCase {

    var realm: Realm!

    override func setUpWithError() throws {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "TestRealm"
        realm = try Realm(configuration: config)
    }

    override func tearDownWithError() throws {
        try realm.write { realm.deleteAll() }
        realm = nil
    }

    func test_createExpenseDTO_withValidData_shouldSaveSuccessfully() throws {
        let expenseDTO = ExpenseDTO()
        expenseDTO.name = "Lunch"
        expenseDTO.amount = 12.5
        expenseDTO.date = Date()

        try realm.write { realm.add(expenseDTO) }

        let fetchedExpenses = realm.objects(ExpenseDTO.self)
        XCTAssertEqual(fetchedExpenses.count, 1)
        XCTAssertEqual(fetchedExpenses.first?.name, "Lunch")
    }

    func test_updateExpenseDTO_withValidChanges_shouldUpdateSuccessfully() throws {
        let expenseDTO = ExpenseDTO()
        expenseDTO.name = "Lunch"
        expenseDTO.amount = 12.5
        expenseDTO.date = Date()

        try realm.write { realm.add(expenseDTO) }

        try realm.write {
            expenseDTO.name = "Dinner"
            expenseDTO.amount = 20.0
        }

        let fetchedExpenses = realm.objects(ExpenseDTO.self)
        XCTAssertEqual(fetchedExpenses.count, 1)
        XCTAssertEqual(fetchedExpenses.first?.name, "Dinner")
        XCTAssertEqual(fetchedExpenses.first?.amount, 20.0)
    }

    func test_deleteExpenseDTO_withExistingExpense_shouldDeleteSuccessfully() throws {
        let expenseDTO = ExpenseDTO()
        expenseDTO.name = "Lunch"
        expenseDTO.amount = 12.5
        expenseDTO.date = Date()

        try realm.write { realm.add(expenseDTO) }
        try realm.write { realm.delete(expenseDTO) }

        let fetchedExpenses = realm.objects(ExpenseDTO.self)
        XCTAssertEqual(fetchedExpenses.count, 0)
    }

    func test_createExpenseDTO_withEmptyFields_shouldReturnDefaultValues() throws {
        let expenseDTO = ExpenseDTO()

        XCTAssertTrue(expenseDTO.name.isEmpty)
        XCTAssertEqual(expenseDTO.amount, 0.0)
    }
}
