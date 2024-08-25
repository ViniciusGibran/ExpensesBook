//
//  CategoryDTO.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 24/08/2024.
//

import Foundation
import RealmSwift

class CategoryDTO: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var name: String = ""
    @Persisted var color: String = ""

    convenience init(from model: Category) {
        self.init()
        self.fromModel(model)
    }
    
    func fromModel(_ category: Category) {
        id = category.id
        name = category.name
        color = category.color
    }
}
