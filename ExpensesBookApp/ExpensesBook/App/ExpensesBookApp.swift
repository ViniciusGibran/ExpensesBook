//
//  ExpensesBookApp.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import SwiftUI

@main
struct ExpensesBookApp: App {
    @StateObject private var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            ExpenseCoordinatorView()
                .environmentObject(navigationState)
        }
    }
}

struct ExpenseCoordinatorView: View {
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        switch navigationState.currentView {
        case .history:
            ExpenseHistoryView()
        case .capture:
            CaptureExpenseView()
        case .detail(let image):
            ExpenseDetailView(image: image)
        }
    }
}
