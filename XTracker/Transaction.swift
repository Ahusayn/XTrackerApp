//
//  Transaction.swift
//  XTracker
//
//  Created by mac on 21/12/2024.
//

import Foundation
import SwiftData

@Model
class Transaction: Identifiable {
    var title: String
    var desc: String
    var date: Date
    var amount: Double
    var selectedCategory: Category
    
    init(title: String, desc: String, date: Date, amount: Double, selectedCategory: Category) {
        self.title = title
        self.desc = desc
        self.date = date
        self.amount = amount
        self.selectedCategory = selectedCategory
    }
    
}
