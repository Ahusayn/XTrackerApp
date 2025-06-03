//
//  EditView.swift
//  XTracker
//
//  Created by HSSN on 12/05/2025.
//

import SwiftUI
import SwiftData

struct EditView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @Query(sort: \AccountModel.name) var accounts: [AccountModel]
    var categories: [Category] = CategoryList.categories

    @State private var isSelectAccount = false
    @State private var isSelectCategory = false
    @State private var transactiontype: Bool = true
    @State private var amount: String = "0"
    @State private var comment: String = ""
    @State private var selectedDate = Date()
    @State private var showDatePicker = false

    @State private var selectedCategory: Category = CategoryList.categories.first!
    @State private var selectedAccounts: AccountModel?

    var transactionToEdit: TransactionModel?

    var formattedAmount: String {
        let currencySymbol = Locale.current.currencySymbol ?? "USD"
        return amount.isEmpty ? "\(currencySymbol)0" : "\(currencySymbol)\(amount)"
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                // Account & Category Selection
                HStack(spacing: 10) {
                    Button {
                        isSelectAccount = true
                    } label: {
                        HStack {
                            Text(selectedAccounts?.imageName ?? "💰")
                                .frame(width: 30, height: 30)
                            Text(selectedAccounts?.name ?? "Select")
                                .bold()
                                .foregroundStyle(Color.text)
                                .lineLimit(1)
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .foregroundStyle(Color.text)
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(8)

                    Spacer()

                    Button {
                        isSelectCategory = true
                    } label: {
                        HStack {
                            Image(selectedCategory.imagename)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text(selectedCategory.name)
                                .bold()
                                .foregroundStyle(Color.text)
                                .lineLimit(1)
                                .frame(maxWidth: 80)
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .foregroundStyle(Color.text)
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(8)
                }
                .padding()

                // Amount and Comment Fields
                VStack {
                    Text(formattedAmount)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    TextField("Add Transaction Merchant..", text: $comment)
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                }
                .padding()

                // Custom Keypad
                CustomKeypadView(
                    amount: $amount,
                    showDatePicker: $showDatePicker,
                    selectedDate: $selectedDate,
                    comment: $comment,
                    selectedCategory: selectedCategory,
                    selectedAccounts: selectedAccounts ?? AccountModel(name: "", imageName: "", balance: 0),
                    isEditing: true,
                    originalTransaction: transactionToEdit,
                    onSave: { dismiss() }
                )
            }
            .onAppear {
                if let tx = transactionToEdit {
                    amount = String(Int(tx.amount))
                    comment = tx.comment
                    selectedDate = tx.date
                    selectedCategory = tx.selectedCategory
                    selectedAccounts = tx.account ?? accounts.first
                } else {
                    selectedAccounts = accounts.first
                }
            }
            .sheet(isPresented: $isSelectAccount) {
                AccountIcons(selectedAccounts: $selectedAccounts)
            }
            .sheet(isPresented: $isSelectCategory) {
                CategoryIcons(selectedCategory: $selectedCategory)
                    .presentationDetents([.fraction(0.5), .large])
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditView(transactionToEdit: transactionPreviewData)
                .preferredColorScheme(.light)

            EditView(transactionToEdit: transactionPreviewData)
                .preferredColorScheme(.dark)
        }
    }
} 
