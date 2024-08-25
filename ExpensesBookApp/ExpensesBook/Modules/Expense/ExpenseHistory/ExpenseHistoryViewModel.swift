//
//  ExpenseHistoryViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation


class ExpenseHistoryViewModel: ObservableObject, StateViewModel {
    @Published var viewState: ViewState = .idle
    @Published var expensesByMonth: [String: [Expense]] = [:]
    
    private var expenseRepository: ExpenseRepositoryProtocol
    
    init(expenseRepository: ExpenseRepositoryProtocol = ExpenseRepository()) {
        self.expenseRepository = expenseRepository
    }
    
    @MainActor
    func loadExpenses() async {
        setState(.loading)
        
        do {
            let expenses = try await self.expenseRepository.getAllExpenses()
            let groupedExpensesByMonth = Dictionary(grouping: expenses) { expense -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                return dateFormatter.string(from: expense.date)
            }
            
            self.expensesByMonth = groupedExpensesByMonth
            
            if expenses.isEmpty { setState(.empty) }
            else { setState(.success) }
            
        } catch {
            setState(.error(error))
        }
    }
    
    @MainActor
    func deleteExpense(_ expense: Expense) async {
        do {
            try await expenseRepository.deleteExpense(expense)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            let month = dateFormatter.string(from: expense.date)
            
            if let index = expensesByMonth[month]?.firstIndex(of: expense) {
                expensesByMonth[month]?.remove(at: index)
                
                if expensesByMonth[month]?.isEmpty == true {
                    expensesByMonth.removeValue(forKey: month)
                }
            }
            
            setState(.success)
        } catch {
            setState(.error(error))
        }
    }
}
