//
//  ExpenseDetailView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI

struct ExpenseDetailView: View {
    @StateObject var viewModel: ExpenseDetailViewModel
    @EnvironmentObject var router: Router
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Receipt Preview
            if let image = viewModel.receiptImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding()
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        router.routeTo(.captureExpense)
                    }) {
                        Text("Add Receipt")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 16)
            }
            
            // Expense Form Fields
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Expense Name", text: $viewModel.expenseName)
                    TextField("Amount", value: $viewModel.amount, format: .currency(code: Locale.current.identifier))
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    Button(action: {
                        router.routeTo(.categoryList)
                    }) {
                        HStack {
                            Text("Category")
                                .foregroundColor(.black)
                            Spacer()
                            if let category = viewModel.selectedCategory {
                                category.coloredCircle
                                Text(category.name)
                            } else {
                                Text("Select Category")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 100)
                }
            }

            // Save Button
            Button(action: {
                Task {
                    do {
                        try await viewModel.saveExpense()
                        router.popToPrevious()
                    } catch {
                        print("Failed to save expense: \(error)")
                    }
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isSaveButtonEnabled ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isSaveButtonEnabled)
            .padding()
        }
        .background(Color(UIColor.systemGray6)) // Keeps the background color consistent
        .onReceive(NotificationCenter.default.publisher(for: .categorySelected)) { notification in
            if let category = notification.object as? Category {
                viewModel.selectedCategory = category
            }
        }
        .onAppear {
            viewModel.prepareForEditing()
        }
    }
}
