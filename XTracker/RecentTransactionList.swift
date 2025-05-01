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

    var selectedType: SelectedSpendType
    
    var filteredTransactions: [TransactionModel] {
        recentTransactions.filter { $0.type == selectedType }
    }
    
    var body: some View {
        VStack {
            HStack {
                // MARK: - Header
                Text("Transaction")
                    .foregroundStyle(Color.text)
                    .bold()
                    .font(.system(size: 20))
                Spacer()
            }
            .padding(.top)
            
            // MARK: - List of Filtered Transactions
            ForEach(Array(filteredTransactions.enumerated()), id: \.element) { index, transaction in
                TransactionRow(transaction: transaction)
                
                Divider()
                    .opacity(index == filteredTransactions.count - 1 ? 0 : 1)
            }
        }
        .padding()
        .background(Color.backgroundcolor)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // Optional: Enable delete functionality later
    /*
    private func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transaction = filteredTransactions[index]
            context.delete(transaction)
        }

        do {
            try context.save()
            print("Transaction Deleted Successfully")
        } catch {
            print("Error deleting the transaction: \(error.localizedDescription)")
        }
    }
    */
}

struct RecentTransactionList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecentTransactionList(selectedType: .expense)
                .preferredColorScheme(.light)
            
            RecentTransactionList(selectedType: .income)
                .preferredColorScheme(.dark)
        }
    }
}
