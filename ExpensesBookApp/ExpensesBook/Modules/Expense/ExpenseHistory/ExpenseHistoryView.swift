//
//  ExpenseHistoryView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 20/08/2024.
//

import SwiftUI

struct ExpenseHistoryView: View {
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var viewModel = ExpenseHistoryViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background list of expenses
                List {
                    ForEach(viewModel.expensesByMonth.keys.sorted(), id: \.self) { month in
                        Section(header: Text(month)) { 
                            ForEach(viewModel.expensesByMonth[month] ?? []) { expense in
                                ExpenseItemView(expense: expense)
                                    .onTapGesture {
                                        // Navigate to edit/capture view (to be implemented)
                                    }
                            }
                            .onDelete { indexSet in
                                if let expenseToDelete = viewModel.expensesByMonth[month]?[indexSet.first!] {
                                    viewModel.deleteExpense(expenseToDelete)
                                }
                            }
                        }
                    }
                }
                
                // Floating action button
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            navigationState.navigationTrigger.send(.showDetail(nil))
                        }) {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 4, x: 0, y: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Expenses")
        }
        .onAppear {
            Task {
                await viewModel.loadExpenses()
            }
        }
    }
}

struct ExpenseHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseHistoryView()
    }
}

// MARK: - ExpenseItemView - TODO: Move to own file

struct ExpenseItemView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expenseDateFormatted(expense.date))
                    .font(.system(size: 14, weight: .bold))
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
        dateFormatter.dateFormat = "dd/EEE" // "18/Mon" format
        return dateFormatter.string(from: date)
    }
}

struct ExpenseItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCategory = Category(name: "Food", color: "#FF6347")
        let sampleExpense = Expense(name: "Dinner", amount: 12.50, date: Date(), category: sampleCategory)
        ExpenseItemView(expense: sampleExpense)
            .previewLayout(.sizeThatFits)
    }
}
