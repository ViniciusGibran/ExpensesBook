//
//  FloatingActionButton.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 22/08/2024.
//

import SwiftUI

struct FloatingActionButton: View {
    let action: () -> Void
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Spacer() // Pushes the button to the bottom
            HStack {
                Spacer() // Pushes the button to the right
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(color)
                        .clipShape(Circle())
                        .shadow(color: .gray, radius: 4, x: 0, y: 4) // Gives the button an elevated look
                }
                .padding()
            }
        }
    }
}
