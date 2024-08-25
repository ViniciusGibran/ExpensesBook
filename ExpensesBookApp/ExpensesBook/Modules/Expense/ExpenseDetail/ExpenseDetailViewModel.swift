//
//  ExpenseDetailViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI
import Combine

@MainActor
class ExpenseDetailViewModel: ObservableObject {
    @Published var expense: Expense
    
    private var expenseRepository: ExpenseRepositoryProtocol

    //var isEditing: Bool { expense.id != ObjectId.generate() }
    
    var isSaveButtonEnabled: Bool {
        !expense.name.isEmpty && expense.amount > .zero
    }
    
    init(expenseRepository: ExpenseRepositoryProtocol = ExpenseRepository(), expense: Expense? = nil) {
        self.expenseRepository = expenseRepository
        self.expense = expense ?? Expense.newExpense()
    }
    
    // Save the expense
    func saveExpense() async throws {
        guard isSaveButtonEnabled else { throw ExpenseError.invalidData }
        
        do {
            try await expenseRepository.saveExpense(expense)
        } catch {
            print("Failed to save expense: \(error.localizedDescription)")
            // Handle the error, e.g., show an alert to the user
        }
    }
    
    func captureReceipt() {
        // Logic to start capturing the receipt
    }
    
    // HERE TODO: add a new ViewState enum to handle view errors
    enum ExpenseError: Error {
        case invalidData
    }
}
