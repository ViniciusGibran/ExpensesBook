//
//  CaptureExpenseView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI

struct CaptureExpenseView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: CaptureExpenseViewModel
    
    var body: some View {
        ZStack {
            if let receiptUIImage = viewModel.receiptUIImage {
                VStack {
                    Image(uiImage: receiptUIImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding()
                    Button(action: { viewModel.showScanner() }) {
                        Text("Rescan")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            } else {
                Button(action: { viewModel.showScanner() }) {
                    VStack {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        Text("Add Receipt")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 16)
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingScanner) {
            DocumentCameraView { scannedImage in
                viewModel.handleScannedImage(scannedImage)
            }
        }
    }
}
