//
//  ExpenseDTO.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 24/08/2024.
//

import Foundation
import RealmSwift

class ExpenseDTO: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var amount: Double = 0.0
    @Persisted var date: Date = Date()
    @Persisted var notes: String?
    @Persisted var receiptImageData: Data?
    @Persisted var categoryId: ObjectId?
    
    convenience init(from model: Expense) {
        self.init()
        self.fromModel(model)
    }

    func fromModel(_ expense: Expense) {
        self.id = expense.id
        self.name = expense.name
        self.amount = expense.amount
        self.date = expense.date
        self.notes = expense.notes
        self.receiptImageData = expense.receiptImage
        self.categoryId = expense.categoryId
    }
}
