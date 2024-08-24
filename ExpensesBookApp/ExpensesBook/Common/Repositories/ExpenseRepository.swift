//
//  ExpenseRepository.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation
import RealmSwift

protocol ExpenseRepositoryProtocol {
    func getAllExpenses() async -> [Expense]
    func saveExpense(_ expense: Expense) async
    func deleteExpense(_ expense: Expense) async
}

class ExpenseRepository: ExpenseRepositoryProtocol {
    private let realmDataManager: RealmDataManager
    
    init(realmDataManager: RealmDataManager = RealmDataManager()) {
        self.realmDataManager = realmDataManager
    }
    
    func getAllExpenses() async -> [Expense] {
        do {
            let expenses = try await realmDataManager.loadAllAsync(Expense.self)
            
            // Link categories based on categoryId
            for expense in expenses {
                if let categoryId = expense.categoryId {
                    // Fetch the category by its ID
                    if let category = try await realmDataManager.loadAsync(Category.self, byPrimaryKey: categoryId) {
                        expense.category = category
                    }
                }
            }
            
            return expenses
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveExpense(_ expense: Expense) async {
        do {
            // Check if the expense already exists
            if await realmDataManager.objectExists(Expense.self, byPrimaryKey: expense._id) {
                // Update the existing expense
                if let existingExpense = try await realmDataManager.loadAsync(Expense.self, byPrimaryKey: expense._id) {
                    existingExpense.name = expense.name
                    existingExpense.amount = expense.amount
                    existingExpense.date = expense.date
                    existingExpense.categoryId = expense.categoryId
                    existingExpense.notes = expense.notes
                    existingExpense.receiptImage = expense.receiptImage
                    try await realmDataManager.saveAsync(existingExpense)
                }
            } else {
                // Save the new expense
                try await realmDataManager.saveAsync(expense)
            }
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
        }
    }
    
    func deleteExpense(_ expense: Expense) async {
        do {
            try await realmDataManager.deleteAsync(expense)
        } catch {
            print("Error deleting expense: \(error.localizedDescription)")
        }
    }
}
