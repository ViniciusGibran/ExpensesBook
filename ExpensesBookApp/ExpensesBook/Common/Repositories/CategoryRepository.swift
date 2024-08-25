//
//  CategoryRepository.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 20/08/2024.
//

import Foundation

protocol CategoryRepositoryProtocol {
    func getAllCategories() async -> [Category]
    func saveCategory(_ category: Category) async
    func deleteCategory(_ category: Category) async
}

class CategoryRepository: CategoryRepositoryProtocol {
    private let realmDataManager: RealmDataManager
    
    init(realmDataManager: RealmDataManager = RealmDataManager()) {
        self.realmDataManager = realmDataManager
    }
    
    func getAllCategories() async -> [Category] {
        do {
            // Fetch the CategoryDTOs from Realm
            let categoryDTOs = try await realmDataManager.loadAllAsync(CategoryDTO.self)
            
            // Convert DTOs to Struct Models
            let categories = categoryDTOs.map { Category(from: $0) }
            
            return categories
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveCategory(_ category: Category) async {
        do {
            let categoryDTO = CategoryDTO(from: category)
            try await realmDataManager.saveAsync(categoryDTO)
        } catch {
            print("Error saving category: \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(_ category: Category) async {
        do {
            let categoryDTO = CategoryDTO(from: category)
            try await realmDataManager.deleteAsync(categoryDTO)
        } catch {
            print("Error deleting category: \(error.localizedDescription)")
        }
    }
}
