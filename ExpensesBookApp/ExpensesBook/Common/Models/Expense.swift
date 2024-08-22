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
    @Persisted var category: Category?
    @Persisted var notes: String? = nil
    @Persisted var receiptImage: Data? = nil
    
    
    
    convenience init(name: String,
                     amount: Double,
                     date: Date,
                     category: Category?,
                     notes: String?,
                     receiptImage: Data?)
    {
        self.init()
        self.name = name
        self.amount = amount
        self.date = date
        self.category = category
        self.notes = notes
        self.receiptImage = receiptImage
    }
}
