//
//  ExpenseHistoryViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation

class ExpenseHistoryViewModel: ObservableObject, StateViewModel {
    @Published var viewState: ViewState = .idle
    @Published var groupedExpensesByMonth: [String: [Expense]] = [:]
    @Published var searchText: String = ""
    
    private var allExpenses: [Expense] = []
    private var expenseRepository: ExpenseRepositoryProtocol
    
    init(expenseRepository: ExpenseRepositoryProtocol = ExpenseRepository()) {
        self.expenseRepository = expenseRepository
    }
    
    @MainActor
    func loadExpenses() async {
        setState(.loading)
        
        do {
            allExpenses = try await expenseRepository.getAllExpenses()
            filterExpenses()
            
            setState(allExpenses.isEmpty ? .empty : .success)
        } catch {
            setState(.error(error))
        }
    }
    
    @MainActor
    func deleteExpense(_ expense: Expense) {
        Task {
            try await expenseRepository.deleteExpense(expense)
            await loadExpenses()
        }
    }
    
    func filterExpenses() {
        let filteredExpenses = searchText.isEmpty ? allExpenses : allExpenses.filter { expense in
            expense.name.localizedCaseInsensitiveContains(searchText)
        }
        
        groupedExpensesByMonth = Dictionary(grouping: filteredExpenses) { expense -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: expense.date)
        }
    }
}
