//
//  CategoryRepositoryTests.swift
//  ExpensesBookTests
//
//  Created by Vinicius Gibran on 26/08/2024.
//

import XCTest
import RealmSwift
@testable import ExpensesBook

final class CategoryRepositoryTests: XCTestCase {

    static var tempRealmURL: URL!

    var realmDataManager: RealmDataManager!
    var repository: CategoryRepository!

    override class func setUp() {
        super.setUp()
        tempRealmURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TestCategoryRealm.realm")
    }

    override func setUpWithError() throws {
        var config = Realm.Configuration(fileURL: Self.tempRealmURL)
        config.deleteRealmIfMigrationNeeded = true
        
        realmDataManager = RealmDataManager(configuration: config)
        repository = CategoryRepository(realmDataManager: realmDataManager)
    }

    override func tearDownWithError() throws {
        try realmDataManager.clearDatabase()
        realmDataManager = nil
        repository = nil

        if let realmURL = Self.tempRealmURL {
            try FileManager.default.removeItem(at: realmURL)
        }
    }

    override class func tearDown() {
        tempRealmURL = nil
        super.tearDown()
    }

    func test_createCategory_withValidData_shouldSaveSuccessfully() async throws {
        let category = Category(name: "Food", color: "#FF0000")
        try await repository.saveCategory(category)

        let fetchedCategories = try await repository.getAllCategories()
        XCTAssertEqual(fetchedCategories.count, 1)
        XCTAssertEqual(fetchedCategories.first?.name, "Food")
        XCTAssertEqual(fetchedCategories.first?.color, "#FF0000")
    }

    func test_updateCategory_withValidChanges_shouldUpdateSuccessfully() async throws {
        var category = Category(name: "Food", color: "#FF0000")
        try await repository.saveCategory(category)

        category.name = "Travel"
        category.color = "#00FF00"
        try await repository.saveCategory(category)

        let fetchedCategories = try await repository.getAllCategories()
        XCTAssertEqual(fetchedCategories.count, 1)
        XCTAssertEqual(fetchedCategories.first?.name, "Travel")
        XCTAssertEqual(fetchedCategories.first?.color, "#00FF00")
    }

    func test_deleteCategory_withExistingCategory_shouldDeleteSuccessfully() async throws {
        let category = Category(name: "Food", color: "#FF0000")
        try await repository.saveCategory(category)
        try await repository.deleteCategory(category)
        
        let fetchedCategories = try await repository.getAllCategories()
        XCTAssert(!fetchedCategories.contains(category))
    }
}
