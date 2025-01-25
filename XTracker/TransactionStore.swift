//
//  TransactionStore.swift
//  XTracker
//
//  Created by HSSN on 16/01/2025.
//

import Foundation

class TransactionStore: ObservableObject {
    @Published var transactions: [TransactionModel] = []

    func addTransaction(_ transaction: TransactionModel) {
        transactions.append(transaction)
    }
}

