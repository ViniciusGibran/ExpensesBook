//
//  Expense.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import SwiftUI
import RealmSwift

struct Expense: Identifiable, Hashable {
    
    // MARK: - Properties
    
    let id: ObjectId
    var name: String
    var amount: Double
    var date: Date
    var notes: String?
    var receiptImage: Data?
    var categoryId: ObjectId?
    var category: Category?

    var receiptImageView: Image? {
        guard let receiptImage = receiptImage, let uiImage = UIImage(data: receiptImage) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
    // MARK: - Inits
    
    init(name: String,
         amount: Double,
         date: Date,
         notes: String?,
         receiptImage: Data?,
         category: Category?)
    {
        self.id = ObjectId.generate()
        self.name = name
        self.amount = amount
        self.date = date
        self.notes = notes
        self.receiptImage = receiptImage
        self.category = category
        self.categoryId = category?.id
    }

    init(from dto: ExpenseDTO) {
        self.id = dto.id
        self.name = dto.name
        self.amount = dto.amount
        self.date = dto.date
        self.notes = dto.notes
        self.receiptImage = dto.receiptImageData
        self.categoryId = dto.categoryId
    }
}

// MARK: - Empty Expension

extension Expense {
    static func newExpense() -> Expense {
         return Expense(
             name: "",
             amount: 0.0,
             date: Date(),
             notes: nil,
             receiptImage: nil,
             category: nil
         )
     }
}
