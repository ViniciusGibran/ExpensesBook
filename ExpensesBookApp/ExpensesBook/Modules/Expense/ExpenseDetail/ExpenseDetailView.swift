//
//  ExpenseDetailView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI

struct ExpenseDetailView: View {
    @EnvironmentObject var navigationState: NavigationState
    @StateObject var viewModel = ExpenseDetailViewModel() // Attach the ViewModel

    var body: some View {
        VStack {
            // Receipt Image Preview
            if let image = viewModel.receiptImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.bottom)
            }

            // Form Fields
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Expense Name", text: $viewModel.expenseName)
                    TextField("Amount", value: $viewModel.amount, format: .currency(code: Locale.current.identifier))
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    // Category Picker (to be implemented)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $viewModel.notes)
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
                Task {
                    do {
                        try await viewModel.saveExpense()
                        // Navigate back to the history view after saving
                        navigationState.navigationTrigger.send(.backToHistory)
                    } catch {
                        // Handle save error (e.g., show an alert)
                    }
                }
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
