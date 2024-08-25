//
//  Image+Extension.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 25/08/2024.
//

import SwiftUI

extension Image {
    static func fromUIImage(_ uiImage: UIImage?) -> Image? {
        guard let uiImage = uiImage else { return nil}
        return Image(uiImage: uiImage)
    }
}
