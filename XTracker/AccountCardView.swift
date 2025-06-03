//
//  AccountCardView.swift
//  XTracker
//
//  Created by HSSN on 22/05/2025.
//



import SwiftUI
import SwiftData

struct AccountCardView: View {
    var accounts: AccountModel

    @Query private var allTransactions: [TransactionModel]

    // Filter transactions by account
    var accountTransactions: [TransactionModel] {
        allTransactions.filter { $0.account?.id == accounts.id }
    }

    var income: Double {
        accountTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var expense: Double {
        accountTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    var balance: Double {
        income - expense
    }

    var body: some View {
        VStack {
            HStack {
                Text(accounts.imageName)
                    .frame(width: 20, height: 20)

                Text("\(accounts.name)'s Balance")
                    .font(.headline)
                    .foregroundStyle(Color.primary.opacity(0.3))
                    .multilineTextAlignment(.center)
            }

            Text(balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(Color.text)
                .lineLimit(1)

            HStack(spacing: 80) {
                VStack {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .frame(width: 30, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green.opacity(0.2))
                            )
                            .foregroundStyle(Color.green)

                        Text("Income")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 20))
                            .baselineOffset(1)
                    }

                    Text(income, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.text)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .padding(.leading, 10)
                }

                VStack {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.up")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .frame(width: 30, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red.opacity(0.2))
                            )
                            .foregroundStyle(Color.red)

                        Text("Expense")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 20))
                            .baselineOffset(1)
                    }

                    Text(expense, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.text)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.brown.opacity(0.3))
        )
        .padding(.horizontal)
    }
}


struct AccountCardView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCardView(accounts: accountPreviewData)
            .preferredColorScheme(.light)

        AccountCardView(accounts: accountPreviewData)
            .preferredColorScheme(.dark)
    }
}
