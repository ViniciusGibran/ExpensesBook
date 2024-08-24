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
    @Persisted var amount: Double = 0.0
    @Persisted var date: Date = Date()
    @Persisted var notes: String? = nil
    @Persisted var receiptImage: Data? = nil
    @Persisted var categoryId: ObjectId?
    
    var category: Category?
    
    convenience init(name: String,
                     amount: Double,
                     date: Date,
                     notes: String?,
                     receiptImage: Data?,
                     category: Category? = nil,
                     categoryId: ObjectId? = nil)
    {
        self.init()
        self.name = name
        self.amount = amount
        self.date = date
        self.notes = notes
        self.receiptImage = receiptImage
        self.category = category
        self.categoryId = categoryId
    }
}
