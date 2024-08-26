//
//  CategoryListViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 22/08/2024.
//

import Foundation
import SwiftUI
import RealmSwift

class CategoryListViewModel: ObservableObject, StateViewModel {
    @Published var categories: [Category] = []
    @Published var viewState: ViewState = .idle
    
    private var categoryRepository: CategoryRepositoryProtocol

    init(categoryRepository: CategoryRepositoryProtocol = CategoryRepository()) {
        self.categoryRepository = categoryRepository
    }
    
    @MainActor
    func loadCategories() {
        Task {
            setState(.loading)
            do {
                let loadedCategories = try await categoryRepository.getAllCategories()
                categories = loadedCategories.sorted { $0.name.lowercased() < $1.name.lowercased() }
                setState(categories.isEmpty ? .empty : .success)
            } catch {
                setState(.error(error))
            }
        }
    }
    
    @MainActor
    func saveCategory(_ category: Category) {
        Task {
            do {
                try await categoryRepository.saveCategory(category)
                loadCategories()
            } catch {
                setState(.error(error))
            }
        }
    }
    
    func selectCategory(_ category: Category) {
        NotificationCenter.default.post(name: .categorySelected, object: category)
    }
    
    // HERE TODO:
    func deleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let categoryToDelete = categories[index]
        
        Task {
            do {
                try await categoryRepository.deleteCategory(categoryToDelete)
                categories.remove(atOffsets: offsets)
            } catch {
                setState(.error(error))
            }
        }
    }
}
