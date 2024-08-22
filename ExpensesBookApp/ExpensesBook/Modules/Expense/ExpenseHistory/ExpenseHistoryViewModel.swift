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
    
    // TMP Mock categories and expenses
    
    lazy private var mockCategories: [Category] = [
        Category(name: "Food", color: "#FF6347"),
        Category(name: "Transport", color: "#1E90FF"),
        Category(name: "Shopping", color: "#32CD32")
    ]
    
    lazy private var mockExpenses: [Expense] = [
        //Expense(name: "Lunch", amount: 15.0, date: Date(), category: mockCategories[0], ),
        //Expense(name: "Taxi", amount: 20.0, date: Date(), category: mockCategories[1]),
        // Expense(name: "Groceries", amount: 50.0, date: Date(), category: mockCategories[0])
    ]
    
    /*
    func loadExpenses() async {
        await MainActor.run {
            let groupedExpensesByMonth = Dictionary(grouping: mockExpenses) { expense -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy" // here note: create a DateFormatterManager just to easily handle dates
                return dateFormatter.string(from: expense.date)
            }
            self.expensesByMonth = groupedExpensesByMonth
        }
    }*/
    
    func deleteExpense(_ expense: Expense) {
        Task {
            await expenseRepository.deleteExpense(expense)
            // Update the grouped expenses after deletion
            await MainActor.run {
                // Identify the month group
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                let month = dateFormatter.string(from: expense.date)
                
                // Safely remove the expense from the group
                if let index = expensesByMonth[month]?.firstIndex(of: expense) {
                    expensesByMonth[month]?.remove(at: index)
                    
                    // If the month group is now empty, remove the month
                    if expensesByMonth[month]?.isEmpty == true {
                        expensesByMonth.removeValue(forKey: month)
                    }
                }
            }
        }
    }
    
    func loadExpenses() async {
        let expenses = await Task.detached { () -> [Expense] in
            return await self.expenseRepository.getAllExpenses()
        }.value
        
        await MainActor.run {
            let groupedExpensesByMonth = Dictionary(grouping: expenses) { expense -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM yyyy"
                return dateFormatter.string(from: expense.date)
            }
            self.expensesByMonth = groupedExpensesByMonth
        }
    }
}
