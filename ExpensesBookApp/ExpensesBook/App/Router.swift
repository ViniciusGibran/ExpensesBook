//
//  Router.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 23/08/2024.
//

import SwiftUI

class Router: ObservableObject {
    
    enum Destination: Hashable {
        case expenseDetail(_ expense: Expense?)
        case categoryList
        case captureExpense
    }
    
    @Published var navPath = NavigationPath()
        
    func routeTo(_ destination: Destination) {
        navPath.append(destination)
    }
    
    func popToPrevious() {
        navPath.removeLast()
    }
    
    func popScreens(_ amount: Int) {
        navPath.removeLast(amount)
    }
    
    func popToRoot() {
        navPath = NavigationPath()
    }
}
