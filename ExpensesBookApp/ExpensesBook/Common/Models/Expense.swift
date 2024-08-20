//
//  Expense.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation
import RealmSwift

class Expense: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var name: String = ""
    @Persisted var date: Date = Date()
    @Persisted var amount: Double = 0.0
    @Persisted var category: Category?
    @Persisted var image: Data? = nil
    @Persisted var notes: String? = nil
    
    
    convenience init(name: String,
         amount: Double,
         date: Date,
         category: Category)
    {
        self.init()
        self.name = name
        self.amount = amount
        self.date = date
        self.category = category
    }
}
