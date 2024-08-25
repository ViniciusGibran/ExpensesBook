//
//  ExpenseDetailViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI
import Combine

class ExpenseDetailViewModel: ObservableObject {
    @Published var expense: Expense
    @Published var amountInput: String = ""
    
    private var expenseRepository: ExpenseRepositoryProtocol
    
    var isSaveButtonEnabled: Bool {
        !expense.name.isEmpty && expense.amount > .zero
    }
    
    init(expenseRepository: ExpenseRepositoryProtocol = ExpenseRepository(), expense: Expense? = nil) {
        self.expenseRepository = expenseRepository
        self.expense = expense ?? Expense.newExpense()
        self.amountInput = self.expense.amount > .zero ? "\(self.expense.amount)" : ""
    }
    
    // Convert amountInput to Double before saving
    @MainActor
    func saveExpense() async throws {
        try await expenseRepository.saveExpense(expense)
    }
    
    
    func formatAndUpdateAmountInput(_ newValue: String) {
        var formattedInput = newValue
        
        if formattedInput.count > 2 {
            formattedInput = formattedInput.replacingOccurrences(of: ".", with: "")
            formattedInput.insert(".", at: formattedInput.index(formattedInput.endIndex, offsetBy: -2))
        }
        
        amountInput = formattedInput
        expense.amount = Double(formattedInput) ?? 0.0
    }
}
