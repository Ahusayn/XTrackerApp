//
//  AccountTransactions.swift
//  XTracker
//
//  Created by HSSN on 25/05/2025.
//

import SwiftUI
import SwiftData

struct AccountTransactions: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
    @Query(sort: \AccountModel.name) private var accounts: [AccountModel]
    
    var selectedSide: SelectedSpendType
    @Binding var selectedAccount: AccountModel?
    
    @State private var selectedTransaction: TransactionModel? = nil
    
    var filterTransactions: [TransactionModel] {
        let filtered = transactions.filter { txn in
            txn.type == selectedSide &&
            txn.account?.id == selectedAccount?.id
        }
        print("Filtered \(filtered.count) transactions for account: \(selectedAccount?.name ?? "None")")
        return filtered
    }

    var body: some View {
        List {
            ForEach(filterTransactions) { transaction in
                Button {
                    selectedTransaction = transaction
                } label: {
                    HStack {
                        Image(transaction.selectedCategory.imagename)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(transaction.selectedCategory.tag.opacity(0.2))
                            )

                        Text(transaction.comment)
                            .foregroundColor(Color.text)

                        Spacer()

                        Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundColor(transaction.selectedCategory.type == .expense ? .red : .green)
                    }
                    .contentShape(Rectangle())
                 
                }
            }
            .onDelete(perform: deleteTransaction)
        }
        .listStyle(.insetGrouped)
        .sheet(item: $selectedTransaction) { transaction in
            EditView(transactionToEdit: transaction)
        }
    }


    func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transactionToDelete = filterTransactions[index]
            
            if let account = transactionToDelete.account {
               switch transactionToDelete.type {
               case .expense:
                   account.removeExpense(transactionToDelete.amount)
               case .income:
                   account.removeIncome(transactionToDelete.amount)
               }
           }
            
            context.delete(transactionToDelete)
        }
        try? context.save()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedAccount: AccountModel? = AccountModel(name: "Cash", imageName: "💵")
        @State private var selectedSide : SelectedSpendType = .expense

        var body: some View {
            AccountTransactions(selectedSide: selectedSide, selectedAccount: $selectedAccount)
        }
    }

    return PreviewWrapper()
}
