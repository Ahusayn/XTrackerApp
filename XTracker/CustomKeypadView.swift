//
//  CustomKeypadView.swift
//  XTracker
//
//  Created by HSSN on 12/05/2025.
//


import SwiftUI
import SwiftData

struct CustomKeypadView: View {
    @Binding var amount: String
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: Date
    @Binding var comment: String

    @Environment(\.modelContext) private var context

    var selectedCategory: Category
    var selectedAccounts: AccountModel
    var isEditing: Bool
    var originalTransaction: TransactionModel?
    var onSave: () -> Void

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedOption: String = "Never"

    let options = ["Monthly", "Weekly", "Daily", "Never"]

    let keypads: [[String]] = [
        ["1", "2", "3", "*"],
        ["4", "5", "6", "date"],
        ["7", "8", "9", ""],
        ["repeat", "0", ".", ""]
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 12) {
                ForEach(0..<keypads.count, id: \.self) { rowIndex in
                    HStack(spacing: 12) {
                        ForEach(0..<keypads[rowIndex].count, id: \.self) { colIndex in
                            let key = keypads[rowIndex][colIndex]
                            if (rowIndex == 2 || rowIndex == 3) && colIndex == 3 {
                                Spacer().frame(width: 80, height: 80)
                            } else {
                                keypadButton(for: key)
                            }
                        }
                    }
                }
            }

            Button(action: {
                handleInput("add")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.black)
                        .frame(width: 80, height: 172)

                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            .padding(.trailing, 2)
            .padding(.bottom, 2)
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
                .presentationDetents([.fraction(0.5)])
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    @ViewBuilder
    func keypadButton(for key: String) -> some View {
        if key == "repeat" {
            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        selectedOption = option
                    } label: {
                        HStack {
                            Text(option)
                            Spacer()
                            if option == selectedOption {
                                Image(systemName: "checkmark").foregroundColor(.blue)
                            }
                        }
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 80)
                    Image(systemName: "repeat")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
        } else {
            Button(action: {
                handleInput(key)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)

                    if key == "*" {
                        Image(systemName: "delete.left").foregroundColor(.red)
                    } else if key == "date" {
                        Image(systemName: "calendar").foregroundColor(.blue)
                    } else {
                        Text(key).font(.title).foregroundColor(.black)
                    }
                }
            }
        }
    }

    func handleInput(_ input: String) {
        let digitCount = amount.filter { $0.isNumber }.count

        switch input {
        case "*":
            if !amount.isEmpty { amount.removeLast() }
        case ".":
            if !amount.contains(".") && amount.count < 12 {
                amount += "."
            }
        case "add":
            guard let amountValue = Double(amount), amountValue > 0 else {
                alertMessage = "Please enter a valid amount"
                showAlert = true
                return
            }

            if comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                alertMessage = "Please enter a merchant name"
                showAlert = true
                return
            }

            if isEditing, let tx = originalTransaction {
                // Remove old transaction effect
                if let oldAccount = tx.account {
                    tx.type == .income
                        ? oldAccount.removeIncome(tx.amount)
                        : oldAccount.removeExpense(tx.amount)
                }

                // Update transaction
                tx.amount = amountValue
                tx.comment = comment
                tx.date = selectedDate
                tx.selectedCategory = selectedCategory
                tx.account = selectedAccounts
                tx.paymentType = selectedAccounts.name
                tx.type = selectedCategory.type
                tx.recurrence = recurrenceFrom(option: selectedOption)

                selectedCategory.type == .income
                    ? selectedAccounts.addIncome(amountValue)
                    : selectedAccounts.addExpense(amountValue)

                do {
                    try context.save()
                    print("Transaction updated")
                } catch {
                    print("Save failed: \(error.localizedDescription)")
                }

            } else {
                // Create new transaction
                let newTransaction = TransactionModel(
                    comment: comment,
                    date: selectedDate,
                    amount: amountValue,
                    recurrence: recurrenceFrom(option: selectedOption),
                    selectedCategory: selectedCategory,
                    paymentType: selectedAccounts.name,
                    account: selectedAccounts
                )

                context.insert(newTransaction)

                selectedCategory.type == .income
                    ? selectedAccounts.addIncome(amountValue)
                    : selectedAccounts.addExpense(amountValue)

                do {
                    try context.save()
                    print("New transaction saved")
                } catch {
                    print("Error saving transaction: \(error.localizedDescription)")
                }
            }

            onSave()

        case "date":
            showDatePicker = true
        case "repeat":
            print("Repeat selected: \(selectedOption)")
        default:
            if digitCount < 12, input.allSatisfy({ $0.isNumber }) {
                amount = (amount == "0") ? input : amount + input
            }
        }
    }

    // 🔁 This function maps string to Recurrence enum
    func recurrenceFrom(option: String) -> Recurrence {
        switch option.lowercased() {
        case "daily": return .daily
        case "weekly": return .weekly
        case "monthly": return .monthly
        case "yearly": return .yearly
        default: return .never
        }
    }

}
