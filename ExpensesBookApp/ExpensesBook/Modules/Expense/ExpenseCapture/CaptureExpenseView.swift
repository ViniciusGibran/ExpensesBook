//
//  CaptureExpenseView.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 21/08/2024.
//

import SwiftUI

struct CaptureExpenseView: View {
    @EnvironmentObject var navigationState: NavigationState
    @State private var scannedImage: UIImage?
    
    var body: some View {
        DocumentCameraView(scannedImage: $scannedImage)
            .onDisappear {
                if let image = scannedImage {
                    navigationState.navigationTrigger.send(.showDetail(image))
                } else {
                    navigationState.navigationTrigger.send(.backToHistory)
                }
            }
    }
}
