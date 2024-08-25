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
    
    private var categoryRepository: CategoryRepositoryProtocol

    // Dependency Injection: Passing the repository for easier testing
    init(categoryRepository: CategoryRepositoryProtocol = CategoryRepository()) {
        self.categoryRepository = categoryRepository
        loadDefaultCategoriesIfNeeded()
    }
    
    // Notify when a category is selected
    func selectCategory(_ category: Category) {
        NotificationCenter.default.post(name: .categorySelected, object: category)
    }

    // Load all categories
    func loadCategories() {
        Task {
            do {
                categories = try await categoryRepository.getAllCategories()
            } catch {
                print("Error loading categories: \(error.localizedDescription)")
            }
        }
    }
    
    // Delete a category
    func deleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let categoryToDelete = categories[index]
        
        Task {
            do {
                try await categoryRepository.deleteCategory(categoryToDelete)
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
                let existingCategories = try await categoryRepository.getAllCategories()
                if existingCategories.isEmpty {
                    try await loadDefaultCategories()
                }
            } catch {
                print("Error loading categories: \(error.localizedDescription)")
            }
        }
    }

    // Load the default categories from a JSON file
    private func loadDefaultCategories() async throws {
        guard let url = Bundle.main.url(forResource: "default_categories", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }

        let decoder = JSONDecoder()
        let defaultCategories = try decoder.decode([Category].self, from: data)

        for category in defaultCategories {
            try await categoryRepository.saveCategory(category)
        }

        // Reload categories after adding defaults
        loadCategories()
    }
}
