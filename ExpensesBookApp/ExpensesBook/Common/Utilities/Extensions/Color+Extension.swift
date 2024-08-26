//
//  Color+Extension.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 24/08/2024.
//

import Foundation
import SwiftUI

extension Color {
    init?(hex: String) {
        let r, g, b: Double
        var hexColor = hex
        
        if hex.hasPrefix("#") { hexColor = String(hex.dropFirst()) }
        
        if hexColor.count == 6, let intCode = Int(hexColor, radix: 16) {
            r = Double((intCode >> 16) & 0xFF) / 255.0
            g = Double((intCode >> 8) & 0xFF) / 255.0
            b = Double(intCode & 0xFF) / 255.0
            self.init(red: r, green: g, blue: b)
        } else {
            return nil
        }
    }
    
    func toHexString() -> String {
        let components = self.cgColor?.components ?? [0, 0, 0, 1]
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
