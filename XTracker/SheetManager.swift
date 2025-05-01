//
//  sheetManager.swift
//  XTracker
//
//  Created by HSSN on 30/04/2025.
//

import Foundation

class SheetManager: ObservableObject {
    @Published var showAddExpenseSelection = false
    @Published var showAddTransactionManually = false
    
    func reset() {
        showAddExpenseSelection = false
        showAddTransactionManually = false
    }
    
}
