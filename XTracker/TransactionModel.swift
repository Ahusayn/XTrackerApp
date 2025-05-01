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
    var comment: String
    var amount: Double
    var selectedCategory: Category
    var date: Date
    var paymentType: String // "Cash" or "Account"
    var account: AccountModel? // Optional account (only used if paymentType == "Account")
    var type: SelectedSpendType

    var dateString: String {
        get {
            date.formatted(.dateTime.year().month().day())
        }
        set {
            if let newDate = DateFormatter.numericUSA.date(from: newValue) {
                date = newDate
            }
        }
    }

    init(comment: String, date: Date, amount: Double, selectedCategory: Category, paymentType: String = "Cash", account: AccountModel? = nil) {
        self.comment = comment
        self.date = date
        self.amount = amount
        self.selectedCategory = selectedCategory
        self.paymentType = paymentType
        self.account = account
        self.type = selectedCategory.type
    }
}
