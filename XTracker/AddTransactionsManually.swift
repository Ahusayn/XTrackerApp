//
//  AddTransactionsManually.swift
//  XTracker
//
//  Created by HSSN on 27/03/2025.
//



import SwiftUI
import SwiftData

struct AddTransactionsManually: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    var isEditing: Bool = false
    var originalTransaction: TransactionModel? = nil

    @State private var isSelectAccount = false
    @State private var isSelectCategory = false
    @State private var showCreateAccount = false

    @State private var transactiontype: Bool = true
    @State var amount: String = "0"
    @State var comment: String = ""
    @State var selectedDate = Date()
    @State var showDatePicker = false
    @State var showRecurring = false

    @State private var rawAmount: String = ""
    @FocusState private var isAmountFocused: Bool

    var categories: [Category] = CategoryList.categories
    @State private var selectedCategory: Category = CategoryList.categories.first!
    @State private var accounts: [AccountModel] = []
    @State private var selectedAccounts: AccountModel?

    var formattedAmount: String {
        let currencySymbol = Locale.current.currencySymbol ?? "₺"
        return amount.isEmpty ? "\(currencySymbol)0" : "\(currencySymbol)\(amount)"
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                // MARK: - Account & Category Pickers
                HStack(spacing: 10) {
                    Button {
                        isSelectAccount = true
                    } label: {
                        Text(selectedAccounts?.imageName ?? "💰")
                            .frame(width: 30, height: 30)

                        Text(selectedAccounts?.name ?? "Select")
                            .bold()
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(8)

                    Spacer()

                    Button {
                        isSelectCategory = true
                    } label: {
                        Image(selectedCategory.imagename)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(selectedCategory.name)
                            .bold()
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: 80)
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(8)
                }
                .padding()

                // MARK: - Amount & Comment
                VStack {
                    Text(formattedAmount)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxHeight: 60)

                    TextField("Add Transaction Merchant..", text: $comment)
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                }
                .padding()

                // MARK: - Custom Keypad
                CustomKeypadView(
                    amount: $amount,
                    showDatePicker: $showDatePicker,
                    selectedDate: $selectedDate,
                    comment: $comment,
                    selectedCategory: selectedCategory,
                    selectedAccounts: selectedAccounts ?? AccountModel(name: "", imageName: "", balance: 0),
                    isEditing: isEditing,
                    originalTransaction: originalTransaction,
                    onSave: { dismiss() }
                )

            }
            .background(Color.background)
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $isSelectAccount) {
                VStack {
                    AccountIcons(selectedAccounts: $selectedAccounts)

//                    Button(action: {
//                        showCreateAccount = true
//                    }) {
//                        Label("Create New Account", systemImage: "plus.circle")
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.accentColor.opacity(0.2))
//                            .cornerRadius(10)
//                    }
//                    .padding()
                }
                .presentationDetents([.fraction(0.5), .large])
            }
            .sheet(isPresented: $showCreateAccount, onDismiss: {
                do {
                    accounts = try context.fetch(FetchDescriptor<AccountModel>())
                    if let last = accounts.last {
                        selectedAccounts = last
                    }
                } catch {
                    print("Error fetching updated accounts: \(error.localizedDescription)")
                }
            }) {
                CreateAccounts()
            }
            .sheet(isPresented: $isSelectCategory) {
                CategoryIcons(selectedCategory: $selectedCategory)
                    .presentationDetents([.fraction(0.5), .large])
            }
            .onAppear {
                do {
                    accounts = try context.fetch(FetchDescriptor<AccountModel>())
                    if selectedAccounts == nil {
                        selectedAccounts = accounts.first
                    }
                } catch {
                    print("Failed to fetch accounts: \(error.localizedDescription)")
                }

                if isEditing, let transaction = originalTransaction {
                    amount = String(Int(transaction.amount))
                    comment = transaction.comment
                    selectedDate = transaction.date
                    selectedCategory = transaction.selectedCategory
                    selectedAccounts = transaction.account ?? accounts.first
                }
            }

        }
    }
}

// MARK: - TransactionTypeToggle
struct TransactionTypeToggle: View {
    @Binding var isIncome: Bool

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                isIncome = false
            }) {
                Text("-")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 50, height: 40)
                    .foregroundColor(isIncome ? .gray : .white)
                    .background(isIncome ? Color.gray.opacity(0.3) : Color.red)
            }

            Button(action: {
                isIncome = true
            }) {
                Text("+")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 50, height: 40)
                    .foregroundColor(isIncome ? .white : .gray)
                    .background(isIncome ? Color.green : Color.gray.opacity(0.3))
                    .cornerRadius(12, corners: [.topRight, .bottomRight])
            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct AddTransactionsManually_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddTransactionsManually()
                .preferredColorScheme(.light)

            AddTransactionsManually()
                .preferredColorScheme(.dark)
        }
    }
}
