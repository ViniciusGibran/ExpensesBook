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
    @Published var expenseName: String = ""
    @Published var amount: Double = 0.0
    @Published var date = Date()
    @Published var category: Category?
    @Published var notes: String = ""
    @Published var receiptImage: UIImage?
    
    private var expenseRepository: ExpenseRepositoryProtocol
    
    // Dependency Injection: Passing the repository for easier testing
    init(expenseRepository: ExpenseRepositoryProtocol = ExpenseRepository()) {
        self.expenseRepository = expenseRepository
    }
    
    // Initialize the ViewModel with an existing expense (for editing)
    func loadExpense(_ expense: Expense?) {
        guard let expense = expense else { return }
        expenseName = expense.name
        amount = expense.amount
        date = expense.date
        category = expense.category
        notes = expense.notes ?? ""
        // Load the image if it exists (you'd need to implement image loading logic based on your storage setup)
    }
    
    // Save the expense
    func saveExpense() async throws {
        guard !expenseName.isEmpty, amount > 0 else {
            throw ExpenseError.invalidData
        }
        
        let newExpense = Expense(
            name: expenseName,
            amount: amount,
            date: date,
            category: category,
            notes: notes,
            receiptImage: receiptImage?.pngData() // You'd need to handle how this image is stored/retrieved
        )
        
        await expenseRepository.saveExpense(newExpense)
    }
    
    enum ExpenseError: Error {
        case invalidData
    }
}
