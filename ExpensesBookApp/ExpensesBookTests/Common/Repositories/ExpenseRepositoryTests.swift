//
//  ExpenseRepositoryTests.swift
//  ExpensesBookTests
//
//  Created by Vinicius Gibran on 26/08/2024.
//

import XCTest
import RealmSwift
@testable import ExpensesBook

final class ExpenseRepositoryTests: XCTestCase {
    
    var realm: Realm!
    var realmDataManager: RealmDataManager!
    var repository: ExpenseRepository!
    
    override func setUpWithError() throws {
        let tempDirectory = FileManager.default.temporaryDirectory
        let realmURL = tempDirectory.appendingPathComponent(UUID().uuidString)
        
        var config = Realm.Configuration(fileURL: realmURL)
        config.deleteRealmIfMigrationNeeded = true
        realm = try Realm(configuration: config)
        
        realmDataManager = RealmDataManager(configuration: config)
        repository = ExpenseRepository(realmDataManager: realmDataManager)
    }
    
    override func tearDownWithError() throws {
        try realmDataManager.clearDatabase()
        
        if let realmURL = realm.configuration.fileURL {
            try FileManager.default.removeItem(at: realmURL)
        }
        
        realmDataManager = nil
        repository = nil
        realm = nil
    }
    
    func test_saveExpense_shouldSaveSuccessfully() async throws {
        let expense = Expense(
            name: "Lunch",
            amount: 12.5,
            date: Date(),
            notes: "Tasty lunch",
            receiptImageData: nil,
            category: nil
        )
        
        try await repository.saveExpense(expense)
        
        let fetchedExpenses = try await repository.getAllExpenses()
        XCTAssertEqual(fetchedExpenses.count, 1)
        XCTAssertEqual(fetchedExpenses.first?.name, "Lunch")
        XCTAssertEqual(fetchedExpenses.first?.amount, 12.5)
    }
    
    func test_updateExpense_shouldUpdateSuccessfully() async throws {
        let expense = Expense(
            name: "Lunch",
            amount: 12.5,
            date: Date(),
            notes: "Tasty lunch",
            receiptImageData: nil,
            category: nil
        )
        
        try await repository.saveExpense(expense)
        
        var updatedExpense = expense
        updatedExpense.name = "Dinner"
        updatedExpense.amount = 20.0
        
        try await repository.saveExpense(updatedExpense)
        
        let fetchedExpenses = try await repository.getAllExpenses()
        XCTAssertEqual(fetchedExpenses.count, 1)
        XCTAssertEqual(fetchedExpenses.first?.name, "Dinner")
        XCTAssertEqual(fetchedExpenses.first?.amount, 20.0)
    }
    
    func test_deleteExpense_shouldDeleteSuccessfully() async throws {
        let expense = Expense(
            name: "Lunch",
            amount: 12.5,
            date: Date(),
            notes: "Tasty lunch",
            receiptImageData: nil,
            category: nil
        )
        
        try await repository.saveExpense(expense)
        
        try await repository.deleteExpense(expense)
        
        let fetchedExpenses = try await repository.getAllExpenses()
        XCTAssertEqual(fetchedExpenses.count, 0)
    }
    
    func test_getAllExpenses_shouldReturnEmptyInitially() async throws {
        let fetchedExpenses = try await repository.getAllExpenses()
        XCTAssertTrue(fetchedExpenses.isEmpty)
    }
}
