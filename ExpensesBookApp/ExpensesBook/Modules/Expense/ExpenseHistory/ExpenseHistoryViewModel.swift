//
//  ExpenseHistoryViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation

@MainActor
class ExpenseHistoryViewModel: ObservableObject {
    
    @Published var expensesByMonth: [String: [Expense]] = [:]
    
    private var expenseRepository: ExpenseRepositoryProtocol
    
    init(expenseRepository: ExpenseRepositoryProtocol = ExpenseRepository()) {
        self.expenseRepository = expenseRepository
    }
    
    func loadExpenses() async {
        let expenses = await Task.detached { () -> [Expense] in
            return await self.expenseRepository.getAllExpenses()
        }.value
        
        await MainActor.run {
            let grouped = Dictionary(grouping: expenses) { expense -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                return dateFormatter.string(from: expense.date)
            }
            self.expensesByMonth = grouped
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        Task {
            await expenseRepository.deleteExpense(expense)
            // HERE TODO: properly handle error and expensesByMonth to remove deleted item
        }
    }
}
