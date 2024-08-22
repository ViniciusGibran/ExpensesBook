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
                if viewModel.expensesByMonth.isEmpty {
                    EmptyStateView()
                } else {
                    ExpenseListView(viewModel: viewModel)
                }

                FloatingActionButton {
                    withAnimation {
                        navigationState.navigationTrigger.send(.showDetail(nil))
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

// Subview for the floating action button
struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                //Spacer()
                Button(action: action) {
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
}

// Subview for the empty state
struct EmptyStateView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(systemName: "folder.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Text("No expenses recorded yet")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                Text("Tap the + button to add your first expense")
                    .font(.body)
                    .foregroundColor(.gray)

                Spacer() // Pushes content to center vertically
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// Subview for the expense list
struct ExpenseListView: View {
    @EnvironmentObject var navigationState: NavigationState
    @ObservedObject var viewModel: ExpenseHistoryViewModel
    
    var body: some View {
        List {
            ForEach(sortedMonths, id: \.self) { month in
                Section(header: Text(month)) {
                    ForEach(expenses(for: month), id: \.id) { expense in
                        ExpenseItemView(expense: expense)
                            .onTapGesture {
                                navigationState.navigationTrigger.send(.showDetail(expense))
                            }
                    }
                }
            }
        }
    }
    
    // Precompute the sorted keys
    private var sortedMonths: [String] {
        viewModel.expensesByMonth.keys.sorted()
    }
    
    // Precompute the expenses for a given month
    private func expenses(for month: String) -> [Expense] {
        viewModel.expensesByMonth[month] ?? []
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
