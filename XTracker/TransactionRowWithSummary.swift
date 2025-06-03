//
//  TransactionRowWithSummary.swift
//  XTracker
//
//  Created by HSSN on 28/05/2025.
//

import SwiftUI

struct TransactionRowWithSummary: View {
    let transaction: TransactionModel
    @State private var showEditandDelete = false

    // Computed property for total amount based on recurrence
    var totalAmount: Double {
        switch transaction.recurrence {
        case .daily:
            return transaction.amount * 1
        case .weekly:
            return transaction.amount * 7
        case .monthly:
            return transaction.amount * 30
        case .yearly:
            return transaction.amount * 365
        case .never:
            return transaction.amount
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            
            // MARK: - Category Icon with Background
            Image(transaction.selectedCategory.imagename)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(transaction.selectedCategory.tag.opacity(0.2))
                )

            // MARK: - Title and Payment Type
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.comment)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(transaction.paymentType == "Cash" ? "Cash" : (transaction.account?.name ?? "Account"))
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // MARK: - Amount + Recurrence Summary
            VStack(alignment: .trailing, spacing: 2) {
                Text(transaction.amount,
                     format: .currency(code: Locale.current.currency?.identifier ?? "NGN"))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(transaction.type == .expense ? .red : .green)
                
                if transaction.recurrence != .never {
                    Text("\(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "NGN")) total \(transaction.recurrence.rawValue.lowercased())")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
        }
        .onTapGesture {
            showEditandDelete = true
        }
        
        .sheet(isPresented: $showEditandDelete) {
            EdittandDeleteSelection(transaction: transaction)
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
        }
        
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
    }
}


struct TransactionRowWithSummary_Previews: PreviewProvider {
    
    // Mock category for preview
    static let sampleCategory = Category(
     
        name: "Food",
        imagename: "food", detail: "Food", // Make sure this image exists in assets
        type: .expense, tag: .red
    )
    
    // Mock account for preview     
    static let sampleAccount = AccountModel(name: "Sample Account", imageName: "cash")
    
    // Mock transaction for preview
    static let sampleTransaction = TransactionModel(
        comment: "Groceries",
        date: Date(),
        amount: 10000,
        recurrence: .weekly,
        selectedCategory: sampleCategory,
        paymentType: "Account",
        account: sampleAccount
    )
    
    static var previews: some View {
        TransactionRowWithSummary(transaction: sampleTransaction)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
