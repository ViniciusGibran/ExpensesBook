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

final class ExpenseModelTests: XCTestCase {

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

    func test_createExpense_withValidData_shouldSaveSuccessfully() throws {
        let expense = Expense()
        expense.name = "Lunch"
        expense.amount = 12.5
        expense.date = Date()

        try realm.write { realm.add(expense) }

        let fetchedExpenses = realm.objects(Expense.self)
        XCTAssertEqual(fetchedExpenses.count, 1)
        XCTAssertEqual(fetchedExpenses.first?.name, "Lunch")
    }

    func test_updateExpense_withValidChanges_shouldUpdateSuccessfully() throws {
        let expense = Expense()
        expense.name = "Lunch"
        expense.amount = 12.5
        expense.date = Date()

        try realm.write { realm.add(expense) }

        try realm.write {
            expense.name = "Dinner"
            expense.amount = 20.0
        }

        let fetchedExpenses = realm.objects(Expense.self)
        XCTAssertEqual(fetchedExpenses.count, 1)
        XCTAssertEqual(fetchedExpenses.first?.name, "Dinner")
        XCTAssertEqual(fetchedExpenses.first?.amount, 20.0)
    }

    func test_deleteExpense_withExistingExpense_shouldDeleteSuccessfully() throws {
        let expense = Expense()
        expense.name = "Lunch"
        expense.amount = 12.5
        expense.date = Date()

        try realm.write { realm.add(expense) }
        try realm.write { realm.delete(expense) }

        let fetchedExpenses = realm.objects(Expense.self)
        XCTAssertEqual(fetchedExpenses.count, 0)
    }

    func test_createExpense_withEmptyFields_shouldReturnDefaultValues() throws {
        let expense = Expense()
        
        XCTAssertTrue(expense.name.isEmpty)
        XCTAssertEqual(expense.amount, 0.0)
    }
}
