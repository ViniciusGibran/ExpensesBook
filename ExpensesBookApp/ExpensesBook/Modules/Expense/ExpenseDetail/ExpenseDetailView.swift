//
//  ExpenseDetailView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI

struct ExpenseDetailView: View {
    @EnvironmentObject var navigationState: NavigationState
    @State private var name: String = ""
    @State private var amount: Double = 0.0
    @State private var date: Date = Date()
    @State private var category: Category?
    @State private var notes: String = ""
    
    var image: UIImage?
    
    var body: some View {
        VStack {
            // Optional Receipt Image Preview
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.bottom)
            }

            // Expense Form Fields
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Expense Name", text: $name)
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.identifier))
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    // Category Picker (to be implemented)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                // Capture Receipt Button
                Button(action: {
                    navigationState.navigationTrigger.send(.startCapture)
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Capture Receipt")
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.vertical)
            }
            
            // Save Button
            Button("Save") {
                // Logic to save the expense
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Expense Details")
    }
}
