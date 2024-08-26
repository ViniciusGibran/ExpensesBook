//
//  CategoryViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 20/08/2024.
//

import SwiftUI

@MainActor
class CategoryDetailViewModel: ObservableObject {
    @Published var category: Category

    private var originalCategory: Category?
    
    var isEditing: Bool {
        originalCategory != nil
    }

    init(category: Category? = nil) {
        if let category = category {
            self.category = category
            self.originalCategory = category
        } else {
            self.category = Category(name: "", color: "#000000")
        }
    }
    
    func updateCategoryName(_ newName: String) {
        category.name = newName
    }
    
    func updateCategoryColor(_ newColor: Color) {
        category.color = newColor.toHexString()
    }
    
    func saveCategory(onSave: (Category) -> Void) {
        onSave(category)
    }
}
