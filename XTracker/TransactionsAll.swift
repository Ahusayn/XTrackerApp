//
//  TransactionsPage.swift
//  XTracker
//
//  Created by hsan on 21/11/2024.
//

import SwiftUI
import SwiftData

struct TransactionsAll: View {
    @Query(sort: \TransactionModel.date, order: .forward)
    private var transactionsAll: [TransactionModel]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(transactionsAll) { transaction in
                        TransactionRow(transaction: transaction)
                        Divider()
                    }
                }
               
            }
           
            .navigationTitle("All Transactions")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

#Preview {
    TransactionsAll()
    
}
