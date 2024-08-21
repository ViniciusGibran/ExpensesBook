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
        case detail(UIImage?)
    }
    
    enum NavigationAction {
        case startCapture
        case showDetail(UIImage?)
        case backToHistory
    }
    
    init() {
        navigationTrigger
            .sink { [weak self] action in
                switch action {
                case .startCapture:
                    self?.currentView = .capture
                case .showDetail(let image):
                    self?.currentView = .detail(image)
                case .backToHistory:
                    self?.currentView = .history
                }
            }
            .store(in: &cancellables)
    }
}
