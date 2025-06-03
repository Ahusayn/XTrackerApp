//
//  RecurringTransactions.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//



import SwiftUI
import SwiftData

struct RecurringTransactions: View {
    
    @Query(sort: \TransactionModel.date, order: .reverse) var allTransactions: [TransactionModel]

    var recurringTransactions: [TransactionModel] {
        allTransactions.filter { $0.recurrence != .never }
    }
    
    // Sum of all recurring transaction amounts
    var totalRecurringAmount: Double {
        recurringTransactions.reduce(0) { $0 + $1.amount }
    }
    
    var groupedTransactions: [(key: String, value: [TransactionModel])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: recurringTransactions) { transaction in
            if calendar.isDateInToday(transaction.date) {
                return "Today"
            } else if calendar.isDateInYesterday(transaction.date) {
                return "Yesterday"
            } else {
                return DateFormatter.groupedHeader.string(from: transaction.date)
            }
        }

        return grouped.sorted { lhs, rhs in
            func sortDate(for key: String) -> Date {
                switch key {
                case "Today":
                    return calendar.startOfDay(for: Date())
                case "Yesterday":
                    return calendar.date(byAdding: .day, value: -1, to: Date()) ?? .distantPast
                default:
                    return DateFormatter.groupedHeader.date(from: key) ?? .distantPast
                }
            }
            return sortDate(for: lhs.key) > sortDate(for: rhs.key)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(groupedTransactions, id: \.key) { group in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(group.key)
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal)

                                VStack(spacing: 0) {
                                    let sortedGroup = group.value.sorted { $0.date > $1.date }
                                    ForEach(sortedGroup.indices, id: \.self) { index in
                                        let transaction = sortedGroup[index]

                                        VStack(alignment: .leading, spacing: 4) {
                                            TransactionRowWithSummary(transaction: transaction)

                                           
                                        }

                                        if index < sortedGroup.count - 1 {
                                            Divider()
                                                .padding(.leading, 56)
                                        }
                                    }

                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(.systemGray6))
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Recurring")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    RecurringTransactions()
}
