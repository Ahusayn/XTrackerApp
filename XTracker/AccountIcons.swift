import SwiftUI
import SwiftData

struct AccountIcons: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Query(sort: \AccountModel.name) var savedAccounts: [AccountModel]
    @Query var transactions: [TransactionModel]

    @Binding var selectedAccounts: AccountModel?

    let columns = [GridItem(.adaptive(minimum: 90), spacing: 30)]
    @State private var isAccountsPresented = false

    var body: some View {
        NavigationStack {
            ScrollView {
           
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(savedAccounts, id: \.id) { account in
                        Button {
                            selectedAccounts = account
                            dismiss()
                        } label: {
                            VStack(spacing: 12) {
                                if account.imageName.containsOnlyEmoji {
                                    Text(account.imageName)
                                        .font(.system(size: 30))
                                        .frame(width: 40, height: 40)
                                } else {
                                    Image(account.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                }

                                Text(account.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color.primary)
                                    .lineLimit(1)
                            }
                            .padding(8)
                           
                        }
                    }

                    // Always show "Add" button
                    Button {
                        isAccountsPresented = true
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Add")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color.primary)
                        }
                        .padding(8)
                        
                    }
                }
                .padding()
            }
            .background(Color.background.ignoresSafeArea())
            .navigationTitle("Accounts")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isAccountsPresented, onDismiss: {
            // No need to manually fetch — @Query updates automatically
        }) {
            CreateAccounts()
        }
        .onAppear {
            print("Loaded Accounts: \(savedAccounts.count)")
            for account in savedAccounts {
                let actualBalance = balance(for: account)
                print("\(account.name): \(account.balance) | Actual Balance: \(actualBalance)")
            }
        }
    }

    func balance(for account: AccountModel) -> Double {
        transactions
            .filter { $0.account?.id == account.id }
            .reduce(0.0) { $0 + ($1.type == .income ? $1.amount : -$1.amount) }
    }
}

// MARK: - Preview
struct AccountIcons_Previews: PreviewProvider {
    // Use optional so you can pass nil or a dummy without inserting into context
    @State static private var previewAccount: AccountModel? = nil

    static var previews: some View {
        Group {
            AccountIcons(selectedAccounts: $previewAccount)
                .preferredColorScheme(.light)

            AccountIcons(selectedAccounts: $previewAccount)
                .preferredColorScheme(.dark)
        }
    }
}
