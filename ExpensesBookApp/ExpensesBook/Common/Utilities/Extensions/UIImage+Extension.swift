//
//  Data+Extension.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 25/08/2024.
//

import UIKit

extension UIImage {
    static func fromData(_ data: Data?) -> UIImage? {
        guard let data = data else { return nil}
        return UIImage(data: data)
    }
}
