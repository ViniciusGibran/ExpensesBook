//
//  ExpenseRepository.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation
import RealmSwift

protocol ExpenseRepositoryProtocol {
    func getAllExpenses() async throws -> [Expense]
    func saveExpense(_ expense: Expense) async throws
    func deleteExpense(_ expense: Expense) async throws
}

class ExpenseRepository: ExpenseRepositoryProtocol {
    private let realmDataManager: RealmDataManager

    init(realmDataManager: RealmDataManager = RealmDataManager()) {
        self.realmDataManager = realmDataManager
    }
    
    func getAllExpenses() async throws -> [Expense] {
        do {
            let expenseDTOs = try await realmDataManager.loadAllAsync(ExpenseDTO.self)
            var expenses: [Expense] = expenseDTOs.map { Expense(from: $0) }
            for (index, dto) in expenseDTOs.enumerated() {
                if let categoryId = dto.categoryId {
                    if let categoryDTO = try await realmDataManager.loadAsync(CategoryDTO.self, byPrimaryKey: categoryId) {
                        expenses[index].category = Category(from: categoryDTO)
                    }
                }
            }
            
            return expenses
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
            throw error
        }
    }
    
    func saveExpense(_ expense: Expense) async throws {
        do {
            let expenseDTO = ExpenseDTO(from: expense)
            try await realmDataManager.saveAsync(expenseDTO)
        } catch {
            print("Error saving expense: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteExpense(_ expense: Expense) async throws {
        do {
            let expenseDTO = ExpenseDTO(from: expense)
            try await realmDataManager.deleteAsync(expenseDTO)
        } catch {
            print("Error deleting expense: \(error.localizedDescription)")
            throw error
        }
    }
}
