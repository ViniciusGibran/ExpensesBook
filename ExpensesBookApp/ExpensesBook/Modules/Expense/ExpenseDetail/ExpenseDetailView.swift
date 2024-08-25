//
//  ExpenseDetailView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI

struct ExpenseDetailView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: ExpenseDetailViewModel

    var body: some View {
        VStack {
            // Receipt Preview/Capture
            CaptureExpenseView(viewModel: CaptureExpenseViewModel(receiptUIImage: viewModel.expense.receiptUIImage))
            
            // Expense Form Fields
            Form {
                Section(header: Text("Expense Details")) {
                    // Name
                    HStack {
                        Text("Name:")
                            .foregroundColor(.gray)
                        TextField("Expense Name", text: $viewModel.expense.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // Amount
                    HStack {
                        Text("Amount:")
                            .foregroundColor(.gray)
                        TextField("Amount", text: $viewModel.amountInput)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: viewModel.amountInput) { newValue in
                                viewModel.formatAndUpdateAmountInput(newValue)
                            }
                    }
                    
                    // Date
                    DatePicker("Date", selection: $viewModel.expense.date, displayedComponents: .date)
                        .foregroundColor(.gray)

                    // Category
                    Button(action: {
                        router.routeTo(.categoryList)
                    }) {
                        HStack {
                            Text("Category:")
                                .foregroundColor(.gray)
                            Spacer()
                            if let category = viewModel.expense.category {
                                category.coloredCircle
                                Text(category.name)
                                    .foregroundColor(.blue)
                            } else {
                                Text("Select Category")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: Binding(
                        get: { viewModel.expense.notes ?? "" },
                        set: { viewModel.expense.notes = $0.isEmpty ? nil : $0 }
                    ))
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
        .onReceive(NotificationCenter.default.publisher(for: .categorySelected)) { notification in
            if let category = notification.object as? Category {
                viewModel.expense.category = category
                viewModel.expense.categoryId = category.id
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .receiptCaptured)) { notification in
            if let receiptUIImage = notification.object as? UIImage {
                viewModel.expense.receiptUIImage = receiptUIImage
            }
        }
    }
}
