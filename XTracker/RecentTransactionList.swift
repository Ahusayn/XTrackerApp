//
//  RecentTransactionList.swift
//  XTracker
//
//  Created by mac on 29/12/2024.
//

import SwiftUI
import SwiftData

struct RecentTransactionList: View {
    
    @Environment(\.modelContext) var context
    
    @Query(sort: \TransactionModel.date, order: .forward)
        private var recentTransactions: [TransactionModel]
    
    var body: some View {
        VStack {
            HStack() {
                //MARK: - Header
                Text("Recent Transactions")
                    .bold()
                Spacer()
                
    
                
            }
            .padding(.top)
            
            //MARK: - List of Transactions
            
                ForEach(Array(recentTransactions.enumerated()), id: \.element) { index, transaction in
                    TransactionRow(transaction: transaction)
                    
                    Divider()
                        .opacity(index == recentTransactions.count - 1 ? 0 : 1)

                }
//                .onDelete(perform: deleteTransaction)
            

        }
        .padding()
        .background(Color.backgroundcolor)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
        
       
    }
    
//    private func deleteTransaction(at offsets: IndexSet) {
//        for index in offsets {
//            let transaction = recentTransactions[index]
//            context.delete(transaction)
//        }
//        
//        do {
//            try context.save()
//            print("Transaction Deleted Succesfully")
//        } catch {
//            print("Error deleting the transaction: \(error.localizedDescription)")
//        }
//    }
}

#Preview {
    RecentTransactionList()
        .modelContainer(for: [TransactionModel.self])
}
