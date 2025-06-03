//
//  TransactionRow.swift
//  XTracker
//
//  Created by mac on 25/12/2024.
//



import SwiftUI

struct TransactionRow: View {
    
    var transaction: TransactionModel
    @State private var showEditandDelete = false

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

            // MARK: - Amount
            Text(transaction.amount,
                 format: .currency(code: Locale.current.currency?.identifier ?? "NGN"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(transaction.type == .expense ? .red : .green)
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



struct Transaction_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionRow(transaction: transactionPreviewData)
                .preferredColorScheme(.light)

            TransactionRow(transaction: transactionPreviewData)
                .preferredColorScheme(.dark)
        }
    }
}

