//
//  File.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation
import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var name: String = ""
    @Persisted var color: String = ""
    
    let expenses = LinkingObjects(fromType: Expense.self, property: "category")
}
