//
//  CategoriesPage.swift
//  XTracker
//
//  Created by hssn on 23/11/2024.
//

import SwiftUI
import SwiftData

struct Account: View {
    var categories: [Category] = CategoryList.categories
    
    @Query(sort: \AccountModel.name) var accounts: [AccountModel]
    @Environment(\.modelContext) private var context

    @State private var selectedAccount: AccountModel? = nil
    @State private var selectedSide: SelectedSpendType = .expense

    var allAccounts: [AccountModel] {
        var list = accounts
        if let cash = accounts.first(where: { $0.name == "Cash" }) {
            return [cash] + accounts.filter { $0.name != "Cash" }
        } else {
            return accounts
        }
    }

    var cashAccount: AccountModel? {
        allAccounts.first(where: {$0.name == "Cash"})
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(alignment: .center, spacing: 12) {
                    if !accounts.isEmpty {
                        if let account = selectedAccount {
                            AccountCardView(accounts: account)
                                .padding(.top)
                        }

                        Picker("Select Type", selection: $selectedSide) {
                            ForEach(SelectedSpendType.allCases, id: \.self) {
                                Text($0.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 12)
                        .padding(.top, 4)
                        .frame(width: 200)

                        AccountTransactions(selectedSide: selectedSide, selectedAccount: $selectedAccount)
                            .frame(minHeight: 200)
                            .padding(.top, 4)
                    } else {
                        Spacer()
                        VStack(spacing: 25) {
                            Image(systemName: "wallet.pass")
                                .font(.system(size: 25))
                            Text("No Account Transactions Created")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.primary)
                        }
                        Spacer()
                    }
                }
                .onAppear {
                    if selectedAccount == nil {
                        selectedAccount = accounts.first
                    }

                    
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AccountSelectView(selectedAccount: $selectedAccount)) {
                            Image(systemName: "creditcard.and.123")
                                .symbolRenderingMode(.palette)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Account()
}
