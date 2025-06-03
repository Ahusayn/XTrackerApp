//
//  EdittandDeleteSelection.swift
//  XTracker
//
//  Created by HSSN on 06/05/2025.
//

//
//  EdittandDeleteSelection.swift
//  XTracker
//
//  Created by HSSN on 06/05/2025.
//

import SwiftUI

struct EdittandDeleteSelection: View {

    var transaction: TransactionModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var isEditExpenses = false

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {

                Image(transaction.selectedCategory.imagename)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(transaction.selectedCategory.tag)
                            .opacity(0.2)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.comment)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Text(transaction.account?.name ?? transaction.paymentType)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "NGN"))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(transaction.type == .expense ? .red : .green)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )

            HStack(spacing: 16) {

                Button {
                    if let account = transaction.account {
                        switch transaction.type {
                        case .expense:
                            account.removeExpense(transaction.amount)
                        case .income:
                            account.removeIncome(transaction.amount)
                        }
                    }

                    
                    context.delete(transaction)
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed to delete transaction: \(error.localizedDescription)")  
                    }
                    
                    dismiss()
                } label: {
                    Text("Delete")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: 80)
                        .frame(height: 50)
                        .foregroundStyle(Color.white)
                        .background(Color.red)
                        .cornerRadius(12)
                }

                Button {
                    isEditExpenses = true
                } label: {
                    Text("Edit")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .foregroundColor(.primary)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.brown.opacity(0.5)))
                                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                }
            }
        }
        .sheet(isPresented: $isEditExpenses) {
            EditView(transactionToEdit: transaction)
        }
        .padding()
        .padding(.top, 20)
    }
}

struct EdittandDeleteSelection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EdittandDeleteSelection(transaction: transactionPreviewData)
                .preferredColorScheme(.light)

            EdittandDeleteSelection(transaction: transactionPreviewData)
                .preferredColorScheme(.dark)
        }
    }
}
