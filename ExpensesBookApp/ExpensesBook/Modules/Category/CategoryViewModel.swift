//
//  CategoryViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 20/08/2024.
//

import Foundation

@MainActor
class CategoryViewModel: ObservableObject {
    
    // HERE TODO: make it only one property: category similar to ExpenseDetailViewModel
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category?
    @Published var newCategoryName: String = ""
    @Published var newCategoryColor: String = "#000000"
    
    private var categoryRepository: CategoryRepositoryProtocol
    
    init(categoryRepository: CategoryRepositoryProtocol = CategoryRepository()) {
        self.categoryRepository = categoryRepository
        loadCategories()
    }
    
    func loadCategories() {
        Task {
            categories = await categoryRepository.getAllCategories()
        }
    }
    
    func saveCategory() {
        guard !newCategoryName.isEmpty else {
            // HERE TODO: Handle error: Category name should not be empty
            return
        }
        
        let category = Category(name: newCategoryName, color: newCategoryColor)
        
        Task {
            await categoryRepository.saveCategory(category)
            loadCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        Task {
            await categoryRepository.deleteCategory(category)
            loadCategories()
        }
    }
    
    func selectCategoryForEditing(_ category: Category) {
        selectedCategory = category
        newCategoryName = category.name
        newCategoryColor = category.color
    }
}
