//
//  StateView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 25/08/2024.
//

import Foundation
import SwiftUI

protocol StateViewModel: ObservableObject {
    var viewState: ViewState { get set }
    func setState(_ state: ViewState)
}

// Default implementation for setState
extension StateViewModel {
    func setState(_ state: ViewState) {
        viewState = state
    }
}

enum ViewState: Equatable {
    case idle
    case loading
    case success
    case error(Error)
    case empty
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success), (.empty, .empty):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

enum ViewStateError: Error, LocalizedError {
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Please ensure all fields are filled correctly."
        }
    }
}

struct StateView<Content: View>: View {
    let state: ViewState
    let content: () -> Content

    var body: some View {
        switch state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        case .success:
            content() // Show the main content when the state is success
        case .empty:
            VStack {
                Image(systemName: "folder.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                Text("No items found")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
        case .error(let error):
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.red)
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}
