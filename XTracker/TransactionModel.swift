//
//  Transaction.swift
//  XTracker
//
//  Created by mac on 21/12/2024.
//


import Foundation
import SwiftData

enum Recurrence: String, Codable {
    case never, daily, weekly, monthly, yearly
}

@Model
class TransactionModel: Identifiable {
    var comment: String
    var amount: Double
    var recurrence: Recurrence
    var selectedCategory: Category
    var date: Date
    var paymentType: String // "Cash" or "Account"
    @Relationship var account: AccountModel?  // Must be linked properly
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

    init(comment: String, date: Date, amount: Double, recurrence: Recurrence = .never,  selectedCategory: Category, paymentType: String = "Cash", account: AccountModel? = nil) {
        self.comment = comment
        self.date = date
        self.amount = amount
        self.recurrence = recurrence
        self.selectedCategory = selectedCategory
        self.paymentType = paymentType
        self.account = account
        self.type = selectedCategory.type
        
    }
}
