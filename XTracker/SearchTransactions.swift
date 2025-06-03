//
//  SearchTransactions.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct SearchTransactions: View {
    
    @Environment(\.dismiss) var dismiss
    @Query(sort: \TransactionModel.date, order: .reverse) var transactions: [TransactionModel]
    @State private var searchText = ""

    var filteredTransactions: [TransactionModel] {
        if searchText.isEmpty {
            return transactions
        } else {
            return transactions.filter {
                $0.comment.localizedCaseInsensitiveContains(searchText) ||
                $0.selectedCategory.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }


    var groupedTransactions: [(key: String, value: [TransactionModel])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredTransactions) { transaction in
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
                case "Today": return calendar.startOfDay(for: Date())
                case "Yesterday": return calendar.date(byAdding: .day, value: -1, to: Date()) ?? .distantPast
                default: return DateFormatter.groupedHeader.date(from: key) ?? .distantPast
                }
            }
            return sortDate(for: lhs.key) > sortDate(for: rhs.key)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
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
                                    TransactionRow(transaction: transaction)

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
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                       Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search by name or category")
        }
    }
}

#Preview {
    SearchTransactions()
}
