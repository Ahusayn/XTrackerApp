//
//  BudgetModel.swift
//  XTracker
//
//  Created by HSSN on 28/05/2025.
//

import Foundation
import SwiftData

@Model
class BudgetModel: Identifiable {
    var id: UUID = UUID()
    var amount: Double = 0.0
    var category: Category
    
    
    init(amount: Double, category: Category) {
        self.amount = amount
        self.category = category
    }
}
