//
//  EraseAllTransactions.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//

import SwiftUI
import SwiftData

struct EraseAllTransactions: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var transactions: [TransactionModel]

    @State private var showingConfirmation = false
    @State private var isDeleting = false

    var body: some View {
        VStack(spacing: 20) {
            Text("NOTE")
                .font(.headline)
                .padding()

            Text("This will delete all your transactions permanently.")
                .multilineTextAlignment(.center)
                .foregroundColor(.red)

            Button(role: .destructive) {
                showingConfirmation = true
            } label: {
                Text(isDeleting ? "Deleting..." : "Delete All")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isDeleting || transactions.isEmpty)
            .confirmationDialog("Are you sure you want to delete all transactions?", isPresented: $showingConfirmation, titleVisibility: .visible) {
                Button("Delete All", role: .destructive) {
                    deleteAllTransactions()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding()
    }

    private func deleteAllTransactions() {
        isDeleting = true
        // Delete all transactions in modelContext
        for transaction in transactions {
            modelContext.delete(transaction)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete transactions: \(error.localizedDescription)")
            // Optionally show an alert here
        }
        isDeleting = false
    }
}

#Preview {
    EraseAllTransactions()
}
