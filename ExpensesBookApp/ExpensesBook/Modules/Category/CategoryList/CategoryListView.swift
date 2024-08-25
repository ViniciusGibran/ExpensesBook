//
//  CategoryListView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 22/08/2024.
//

import SwiftUI
import RealmSwift

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryListViewModel
    @EnvironmentObject var router: Router

    @State private var isPresentingCategoryManager = false
    @State private var selectedCategory: Category? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Background list or empty state
                if viewModel.categories.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(viewModel.categories, id: \.id) { category in
                            HStack {
                                category.coloredCircle
                                Text(category.name)
                                Spacer()

                                // Edit Category Button
                                Button(action: {
                                    selectedCategory = category
                                    isPresentingCategoryManager = true
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle()) // Makes the entire row tappable
                            .onTapGesture {
                                viewModel.selectCategory(category)
                                router.popToPrevious() // Navigate back after selection
                            }
                        }
                        .onDelete(perform: viewModel.deleteCategory)
                    }
                    .listStyle(InsetGroupedListStyle()) // Adjusts the list style if needed
                }

                // Floating action button
                FloatingActionButton(action: {
                    selectedCategory = nil
                    isPresentingCategoryManager = true
                }, icon: "plus", color: .blue)
            }
            .navigationTitle("Categories")
            .sheet(isPresented: $isPresentingCategoryManager) {
                CategoryManagerView(category: $selectedCategory) { updatedCategory in
                    // viewModel.saveCategory(updatedCategory) HERE TODO: 
                    viewModel.loadCategories()
                }
            }
            .onAppear {
                viewModel.loadCategories()
            }
        }
    }
}

struct CategoryManagerView: View {
    @Binding var category: Category?
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var color: String = "#000000"
    
    var onSave: (Category) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Details")) {
                    TextField("Category Name", text: $name)
                    ColorPicker("Color", selection: Binding(get: {
                        Color(hex: color) ?? .black
                    }, set: { newColor in
                        color = newColor.toHexString()
                    }))
                }
            }
            .navigationTitle(category == nil ? "New Category" : "Edit Category")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                if let category = category {
                    name = category.name
                    color = category.color
                }
            }
        }
    }
    
    private func saveCategory() {
        let updatedCategory: Category
        if var category = category {
            // Update existing category
            category.name = name
            category.color = color
            updatedCategory = category
        } else {
            // Create a new category
            updatedCategory = Category(name: name, color: color)
        }

        // Call the onSave closure with the updated or new category
        onSave(updatedCategory)
    }
}
