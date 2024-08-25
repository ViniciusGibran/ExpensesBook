//
//  File.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import SwiftUI
import RealmSwift

struct Category: Identifiable, Codable, Hashable {
    
    // MARK: Properties
    
    let id: ObjectId
    var name: String
    var color: String

    var coloredCircle: Text {
        Text("●")
            .foregroundColor(Color(hex: color) ?? .white)
            .font(.system(size: 18))
    }
    
    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
    }

    
    // MARK: - Inits
    
    init(name: String, color: String) {
        self.id = ObjectId.generate()
        self.name = name
        self.color = color
    }
    
    init(from dto: CategoryDTO) {
        self.id = dto.id
        self.name = dto.name
        self.color = dto.color
    }

    /*
    // Custom Decodable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(ObjectId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(String.self, forKey: .color)
    }

    // Encodable method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
    }*/
}
