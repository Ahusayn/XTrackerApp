//
//  TransactionsModel.swift
//  XTracker
//
//  Created by mac on 19/12/2024.
//

import SwiftData
import Foundation

@Model
class TransactionsModel: Identifiable {
    var title: String
    var desc: String
    var amount: Double
    var category: Category // Reference to Category
    var date: Date
    
    init(title: String, desc: String, amount: Double, category: Category, date: Date) {
        self.title = title
        self.desc = desc
        self.amount = amount
        self.category = category
        self.date = date
    }
}
