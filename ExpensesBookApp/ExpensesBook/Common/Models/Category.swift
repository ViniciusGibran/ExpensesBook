//
//  File.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import SwiftUI
import RealmSwift

class Category: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var name: String = ""
    @Persisted var color: String = ""
    
    let expenses = LinkingObjects(fromType: Expense.self, property: "category")
    
    var coloredCircle: Text {
        Text("●")
            .foregroundColor(Color(hex: color) ?? .white)
            .font(.system(size: 18))
    }
    
    convenience init(name: String, color: String) {
        self.init()
        self.name = name
        self.color = color
    }
    
    // MARK: - Codable Conformance

    enum CodingKeys: String, CodingKey {
        case name
        case color
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.color = try container.decode(String.self, forKey: .color)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
    }
}

// HERE TODO: move to Utilities Color+Extension
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
}
