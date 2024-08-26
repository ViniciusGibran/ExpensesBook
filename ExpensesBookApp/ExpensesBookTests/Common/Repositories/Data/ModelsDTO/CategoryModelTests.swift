//
//  CategoryModelTests.swift
//  ExpensesBookTests
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import XCTest
import RealmSwift
@testable import ExpensesBook

final class CategoryModelDTOTests: XCTestCase {

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

    func test_createCategoryDTO_withValidData_shouldSaveSuccessfully() throws {
        let categoryDTO = CategoryDTO()
        categoryDTO.name = "Food"
        categoryDTO.color = "#FF0000"

        try realm.write { realm.add(categoryDTO) }

        let fetchedCategories = realm.objects(CategoryDTO.self)
        XCTAssertEqual(fetchedCategories.count, 1)
        XCTAssertEqual(fetchedCategories.first?.name, "Food")
        XCTAssertEqual(fetchedCategories.first?.color, "#FF0000")
    }

    func test_updateCategoryDTO_withValidChanges_shouldUpdateSuccessfully() throws {
        let categoryDTO = CategoryDTO()
        categoryDTO.name = "Food"
        categoryDTO.color = "#FF0000"

        try realm.write { realm.add(categoryDTO) }

        try realm.write {
            categoryDTO.name = "Travel"
            categoryDTO.color = "#00FF00"
        }

        let fetchedCategories = realm.objects(CategoryDTO.self)
        XCTAssertEqual(fetchedCategories.count, 1)
        XCTAssertEqual(fetchedCategories.first?.name, "Travel")
        XCTAssertEqual(fetchedCategories.first?.color, "#00FF00")
    }

    func test_deleteCategoryDTO_withExistingCategory_shouldDeleteSuccessfully() throws {
        let categoryDTO = CategoryDTO()
        categoryDTO.name = "Food"
        categoryDTO.color = "#FF0000"

        try realm.write { realm.add(categoryDTO) }
        try realm.write { realm.delete(categoryDTO) }

        let fetchedCategories = realm.objects(CategoryDTO.self)
        XCTAssertEqual(fetchedCategories.count, 0)
    }

    func test_createCategoryDTO_withEmptyFields_shouldReturnDefaultValues() throws {
        let categoryDTO = CategoryDTO()

        XCTAssertTrue(categoryDTO.name.isEmpty)
        XCTAssertTrue(categoryDTO.color.isEmpty)
    }
}
