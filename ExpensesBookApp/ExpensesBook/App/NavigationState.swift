//
//  NavigationState.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import Combine
import SwiftUI

class NavigationState: ObservableObject {
    @Published var currentView: CurrentView = .history
    var navigationTrigger = PassthroughSubject<NavigationAction, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum CurrentView {
        case history
        case capture
        case detail(Expense?)
    }
    
    enum NavigationAction {
        case startCapture
        case showDetail(Expense?)
        case backToHistory
    }
    
    init() {
        navigationTrigger
            .sink { [weak self] action in
                switch action {
                case .startCapture:
                    self?.currentView = .capture
                case .showDetail(let expense):
                    self?.currentView = .detail(expense)
                case .backToHistory:
                    self?.currentView = .history
                }
            }
            .store(in: &cancellables)
    }
}
