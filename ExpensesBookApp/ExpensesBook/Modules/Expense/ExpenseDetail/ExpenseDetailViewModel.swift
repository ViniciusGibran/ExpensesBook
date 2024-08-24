//
//  ExpenseDetailViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI
import Combine

class ExpenseDetailViewModel: ObservableObject {
    @Published var expenseName: String = ""
    @Published var amount: Double = 0.0
    @Published var date = Date()
    @Published var selectedCategory: Category?
    @Published var notes: String = ""
    @Published var receiptImage: UIImage?
    
    private var expenseRepository: ExpenseRepositoryProtocol
    private var existingExpense: Expense?
    
    var isEditing: Bool { existingExpense != nil }
    
    var isSaveButtonEnabled: Bool {
        !expenseName.isEmpty && amount > 0
    }
    
    // Dependency Injection: Passing the repository for easier testing
    init(expenseRepository: ExpenseRepositoryProtocol = ExpenseRepository(), expense: Expense? = nil) {
        self.expenseRepository = expenseRepository
        self.existingExpense = expense
    }
    
    // Prepare for editing if an existing expense is provided
    func prepareForEditing() {
        guard let expense = existingExpense else { return }
        expenseName = expense.name
        amount = expense.amount
        date = expense.date
        selectedCategory = expense.category
        notes = expense.notes ?? ""
        // Load receipt image if needed (you’d implement this based on your image storage strategy)
    }
    
    @MainActor
    func loadExpense(_ expense: Expense?) {
        guard let expense = expense else { return }
        self.expenseName = expense.name
        self.amount = expense.amount
        self.date = expense.date
        self.selectedCategory = expense.category
        self.notes = expense.notes ?? ""
    }
    
    // Save the expense
    func saveExpense() async throws {
        guard !expenseName.isEmpty, amount > 0 else {
            throw ExpenseError.invalidData
        }

        if isEditing,
           let existingExpense = self.existingExpense,
           let mutableExpense = existingExpense.thaw() { // Use the existing expense for editing
            mutableExpense.name = expenseName
            mutableExpense.amount = amount
            mutableExpense.date = date
            mutableExpense.notes = notes
            mutableExpense.receiptImage = receiptImage?.pngData()
            mutableExpense.categoryId = selectedCategory?._id

            await expenseRepository.saveExpense(mutableExpense)
        } else {
            // Create a new expense for saving
            let newExpense = Expense(
                name: expenseName,
                amount: amount,
                date: date,
                notes: notes,
                receiptImage: receiptImage?.pngData(),
                categoryId: selectedCategory?._id
            )

            await expenseRepository.saveExpense(newExpense)
        }
    }
    
    func captureReceipt() {
        // Logic to start capturing the receipt (this can be handled with navigationState or other mechanisms)
    }
    
    enum ExpenseError: Error {
        case invalidData
    }
}
