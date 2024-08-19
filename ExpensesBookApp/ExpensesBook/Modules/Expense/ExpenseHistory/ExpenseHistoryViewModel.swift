//
//  ExpenseHistoryViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation
import Combine

class ExpenseHistoryViewModel: ObservableObject {
    
    @Published var expensesByMonth: [String: [Expense]] = [:]
    
    private var expenseRepository: ExpenseRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(expenseRepository: ExpenseRepository = ExpenseRepository()) {
        self.expenseRepository = expenseRepository
        fetchExpenses()
    }
    
    func fetchExpenses() {
        let expenses = expenseRepository.getAllExpenses()
    }
}
