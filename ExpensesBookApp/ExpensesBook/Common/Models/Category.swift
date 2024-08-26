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
            .font(.system(size: 16))
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

    // Custom Decodable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Generate id if it's missing from the JSON
        id = try container.decodeIfPresent(ObjectId.self, forKey: .id) ?? ObjectId.generate()
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(String.self, forKey: .color)
    }
}
