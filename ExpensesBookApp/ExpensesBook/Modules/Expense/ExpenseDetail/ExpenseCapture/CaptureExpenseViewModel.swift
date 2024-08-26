//
//  CaptureExpenseViewModel.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 25/08/2024.
//

import Foundation
import SwiftUI


class CaptureExpenseViewModel: ObservableObject {
    @Published var receiptUIImage: UIImage?
    @Published var isShowingScanner = false
    @Published var isShowingPreview = false
    
    init(receiptUIImage: UIImage? = nil) {
        self.receiptUIImage = receiptUIImage
    }
    
    func showScanner() {
        isShowingScanner = true
    }
    
    func showPreview() {
        guard receiptUIImage != nil else { return }
        isShowingPreview = true
    }
    
    func handleScannedImage(_ uiImage: UIImage) {
        receiptUIImage = uiImage
        NotificationCenter.default.post(name: .receiptCaptured, object: uiImage)
    }
}
