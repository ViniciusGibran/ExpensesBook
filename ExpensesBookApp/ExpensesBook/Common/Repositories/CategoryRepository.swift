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
            return try await realmDataManager.loadAllAsync(Category.self)
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveCategory(_ category: Category) async {
        do {
            try await realmDataManager.saveAsync(category)
        } catch {
            print("Error saving category: \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(_ category: Category) async {
        do {
            try await realmDataManager.deleteAsync(category)
        } catch {
            print("Error deleting category: \(error.localizedDescription)")
        }
    }
}
