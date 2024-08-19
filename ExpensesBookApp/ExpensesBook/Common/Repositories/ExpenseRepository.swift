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
            return try await realmDataManager.loadAllAsync(Expense.self)
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveExpense(_ expense: Expense) async {
        do {
            try await realmDataManager.saveAsync(expense)
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
