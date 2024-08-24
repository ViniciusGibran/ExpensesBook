//
//  CategoryListViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 22/08/2024.
//

import Foundation
import SwiftUI
import RealmSwift

@MainActor
class CategoryListViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    private var realmDataManager: RealmDataManager

    init(realmDataManager: RealmDataManager = RealmDataManager()) {
        self.realmDataManager = realmDataManager
        loadDefaultCategoriesIfNeeded()
    }
    
    func selectCategory(_ category: Category) {
        NotificationCenter.default.post(name: .categorySelected, object: category)
    }

    func loadCategories() {
        Task {
            do {
                let loadedCategories = try await realmDataManager.loadAllAsync(Category.self)
                categories = loadedCategories
            } catch {
                print("Error loading categories: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let categoryToDelete = categories[index]
        
        Task {
            do {
                try await realmDataManager.deleteAsync(categoryToDelete)
                categories.remove(atOffsets: offsets)
            } catch {
                print("Error deleting category: \(error.localizedDescription)")
            }
        }
    }
    
    // Load default categories if no categories exist
    private func loadDefaultCategoriesIfNeeded() {
        Task {
            do {
                let existingCategories = try await realmDataManager.loadAllAsync(Category.self)
                if existingCategories.isEmpty {
                    try await loadDefaultCategories()
                }
            } catch {
                print("Error loading categories: \(error.localizedDescription)")
            }
        }
    }

    private func loadDefaultCategories() async throws {
        guard let url = Bundle.main.url(forResource: "default_categories", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }

        let decoder = JSONDecoder()
        let defaultCategories = try decoder.decode([Category].self, from: data)

        for category in defaultCategories {
            try await realmDataManager.saveAsync(category)
        }

        // Reload categories after adding defaults
        loadCategories()
    }
}
