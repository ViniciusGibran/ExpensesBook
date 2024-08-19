//
//  CategoryModelTests.swift
//  ExpensesBookTests
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import XCTest
import RealmSwift
@testable import ExpensesBook

final class CategoryModelTests: XCTestCase {

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

    func test_createCategory_withValidData_shouldSaveSuccessfully() throws {
        let category = Category()
        category.name = "Food"
        category.color = "#FF0000"

        try realm.write { realm.add(category) }

        let fetchedCategories = realm.objects(Category.self)
        XCTAssertEqual(fetchedCategories.count, 1)
        XCTAssertEqual(fetchedCategories.first?.name, "Food")
        XCTAssertEqual(fetchedCategories.first?.color, "#FF0000")
    }

    func test_updateCategory_withValidChanges_shouldUpdateSuccessfully() throws {
        let category = Category()
        category.name = "Food"
        category.color = "#FF0000"

        try realm.write { realm.add(category) }

        try realm.write {
            category.name = "Travel"
            category.color = "#00FF00"
        }

        let fetchedCategories = realm.objects(Category.self)
        XCTAssertEqual(fetchedCategories.count, 1)
        XCTAssertEqual(fetchedCategories.first?.name, "Travel")
        XCTAssertEqual(fetchedCategories.first?.color, "#00FF00")
    }

    func test_deleteCategory_withExistingExpense_shouldDeleteSuccessfully() throws {
        let category = Category()
        category.name = "Food"
        category.color = "#FF0000"

        try realm.write { realm.add(category) }
        try realm.write { realm.delete(category) }

        let fetchedCategories = realm.objects(Category.self)
        XCTAssertEqual(fetchedCategories.count, 0)
    }
    
    func test_createCategory_withEmptyFields_shouldReturnDefaultValues() throws {
        let expense = Category()
        
        XCTAssertTrue(expense.name.isEmpty)
        XCTAssertTrue(expense.color.isEmpty)
    }
}
