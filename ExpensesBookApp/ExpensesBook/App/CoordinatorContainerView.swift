//
//  NavigationState.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI

struct CoordinatorContainerView: View {
    
    @StateObject private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            ExpenseHistoryView()
                .navigationTitle("Expenses")
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case .expenseDetail(let expense):
                        ExpenseDetailView(viewModel: ExpenseDetailViewModel(expense: expense))
                            .navigationTitle(expense != nil ? "Edit Expense" : "New Expense")
                            .navigationBarTitleDisplayMode(.inline)
                            .background(Color(.systemGray6))
                        
                    case .categoryList:
                        CategoryListView(viewModel: CategoryListViewModel())
                            .navigationTitle("Categories")
                            .navigationBarTitleDisplayMode(.large)
                    }
                }
        }
        .environmentObject(router)
    }
}
