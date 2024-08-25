//
//  StateView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 25/08/2024.
//

import Foundation
import SwiftUI


enum ViewState {
    case idle
    case loading
    case success
    case error(String)
    case empty(String, String) // The associated values can be the message and an optional image name
}

struct StateView: View {
    let state: ViewState
    
    var body: some View {
        switch state {
        case .idle, .success:
            EmptyView() // Nothing is shown in these states
        
        case .loading:
            VStack {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.5)) // Optional: add a translucent background during loading
        
        case .error(let message):
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.red)
                    .padding(.bottom, 16)
                
                Text(message)
                    .font(.title3)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        case .empty(let message, let imageName):
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.bottom, 16)
                
                Text(message)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
