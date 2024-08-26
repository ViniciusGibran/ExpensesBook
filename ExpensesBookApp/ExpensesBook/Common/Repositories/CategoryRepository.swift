//
//  CategoryRepository.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 20/08/2024.
//

import Foundation

protocol CategoryRepositoryProtocol {
    func getAllCategories() async throws -> [Category]
    func saveCategory(_ category: Category) async throws
    func deleteCategory(_ category: Category) async throws
}

class CategoryRepository: CategoryRepositoryProtocol {
    private let realmDataManager: RealmDataManager
    
    init(realmDataManager: RealmDataManager = RealmDataManager()) {
        self.realmDataManager = realmDataManager
    }
    
    func getAllCategories() async throws -> [Category] {
        let existingCategories = try await realmDataManager.loadAllAsync(CategoryDTO.self)
        
        if existingCategories.isEmpty {
            try await saveDefaultCategories()
        }
        
        return try await realmDataManager.loadAllAsync(CategoryDTO.self).map { Category(from: $0) }
    }
    
    func saveCategory(_ category: Category) async throws {
        let categoryDTO = CategoryDTO(from: category)
        try await realmDataManager.saveAsync(categoryDTO)
    }
    
    func deleteCategory(_ category: Category) async throws {
        let categoryDTO = CategoryDTO(from: category)
        try await realmDataManager.deleteAsync(categoryDTO)
    }
    
    private func saveDefaultCategories() async throws {
        guard let url = Bundle.main.url(forResource: "default_categories", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }

        let decoder = JSONDecoder()
        let defaultCategories = try decoder.decode([Category].self, from: data)

        for category in defaultCategories {
            try await saveCategory(category)
        }
    }
}
