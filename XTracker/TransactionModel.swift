//
//  Transaction.swift
//  XTracker
//
//  Created by mac on 21/12/2024.
//

import Foundation
import SwiftData

@Model
class TransactionModel: Identifiable {
    var title: String
    var desc: String
    var amount: Double
    var selectedCategory: Category
    var date: Date // Make this the stored property

    var dateString: String { // Make this computed
        get {
            date.formatted(.dateTime.year().month().day())
        }
        set {
            if let newDate = DateFormatter.numericUSA.date(from: newValue) {
                date = newDate
            }
        }
    }

    init(title: String, desc: String, date: Date, amount: Double, selectedCategory: Category) {
        self.title = title
        self.desc = desc
        self.date = date
        self.amount = amount
        self.selectedCategory = selectedCategory
    }
}


