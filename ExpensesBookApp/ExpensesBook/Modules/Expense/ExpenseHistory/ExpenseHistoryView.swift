//
//  ExpenseHistoryView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 20/08/2024.
//

import SwiftUI

struct ExpenseHistoryView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = ExpenseHistoryViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                StateView(state: viewModel.viewState) {
                    ExpenseListView(viewModel: viewModel) { expense in
                        router.routeTo(.expenseDetail(expense))
                    }
                }
                FloatingActionButton(action: {
                    router.routeTo(.expenseDetail(nil))
                }, icon: "plus", color: .blue)
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.filterExpenses()
            }
            .onAppear {
                Task { await viewModel.loadExpenses() }
            }
        }
    }
}

// MARK: - ExpenseListView

struct ExpenseListView: View {
    @ObservedObject var viewModel: ExpenseHistoryViewModel
    var onSelectExpense: (Expense) -> Void
    
    var body: some View {
        List {
            ForEach(viewModel.groupedExpensesByMonth.keys.sorted(), id: \.self) { month in
                Section(header: Text(month)) {
                    ForEach(viewModel.groupedExpensesByMonth[month] ?? [], id: \.id) { expense in
                        ExpenseItemView(expense: expense)
                            .onTapGesture {
                                onSelectExpense(expense)
                            }
                    }
                }
            }
        }
    }
}

// MARK: - ExpenseItemView

struct ExpenseItemView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expenseDateFormatted(expense.date))
                    .font(.system(size: 15, weight: .bold))
            }
            .frame(width: 60, alignment: .leading)
            
            Text(expense.name)
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("$"+String(format: "%.2f", expense.amount))
                .font(.system(size: 16))
                .frame(alignment: .trailing)
            
            expense.category?.coloredCircle
        }
        .padding(.vertical, 5)
    }
    
    private func expenseDateFormatted(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/EEE"
        return dateFormatter.string(from: date)
    }
}
