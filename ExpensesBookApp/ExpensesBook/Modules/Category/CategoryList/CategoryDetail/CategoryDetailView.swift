//
//  CategoryDetailViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 26/08/2024.
//

import SwiftUI

struct CategoryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: CategoryDetailViewModel
    
    var onSave: (Category) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Details")) {
                    TextField("Category Name", text: Binding(
                        get: { viewModel.category.name },
                        set: { viewModel.updateCategoryName($0) }
                    ))
                    ColorPicker("Color", selection: Binding(
                        get: { Color(hex: viewModel.category.color) ?? .black },
                        set: { viewModel.updateCategoryColor($0) }
                    ))
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Category" : "New Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveCategory(onSave: onSave)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
