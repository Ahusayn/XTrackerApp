//
//  AddExpenseSelectionView.swift
//  XTracker
//
//  Created by HSSN on 17/03/2025.
//

import SwiftUI

struct AddExpenseSelectionView: View {
    @State private var selectedExpense: ExpenseMode?
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Add Expense")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ExpenseOption(icon: "camera", title: "Scan Receipt", subtitle: "Use your camera to quickly capture Transaction details.") {
                    selectedExpense = .scanReceipt
                }

                ExpenseOption(icon: "square.and.pencil", title: "Manual Entry", subtitle: "Manually enter Transaction details.") {
                    selectedExpense = .manualReceipt
                }

                ExpenseOption(icon: "mic", title: "Voice Logging", subtitle: "Quickly add Transactions using voice input.") {
                    selectedExpense = .voiceEntry
                }

                Spacer()
            }
            .padding(.top, 20)
            .background(Color(.systemBackground))
            .cornerRadius(20)
        }
        .sheet(item: $selectedExpense) { expenseMode in
            switch expenseMode {
            case .manualReceipt:
                AddTransactionsManually ()
            case .scanReceipt:
                ReceiptAdd()
            case .voiceEntry:
                AudioExpenseAdderView()
                    .presentationDetents([.fraction(0.5)])
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TransactionSaved"))) { _ in
            selectedExpense = nil  // Dismiss AddTransactionsManually
            dismiss()
        }

    }
}

enum ExpenseMode: Identifiable {
    case manualReceipt, scanReceipt, voiceEntry
    
    var id: Self { self }
}

struct ExpenseOption: View {
    var icon: String
    var title: String
    var subtitle: String
    var action: () -> Void  // Allows tapping without using a Button

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .onTapGesture {   // Handles taps without needing a Button
            action()
        }
    }
}

struct AddExpenseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddExpenseSelectionView()
                .preferredColorScheme(.light)

            AddExpenseSelectionView()
                .preferredColorScheme(.dark)
        }
    }
}
