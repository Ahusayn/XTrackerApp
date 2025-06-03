//
//  RecentTransactionList.swift
//  XTracker
//
//  Created by mac on 29/12/2024.
//



import SwiftUI
import SwiftData

struct RecentTransactionList: View {
    
    @Environment(\.modelContext) var context
    @State private var showEditandDelete = false
    
   
   

    
    @Query(sort: \TransactionModel.date, order: .reverse)
    private var recentTransactions: [TransactionModel]
    
    var selectedType: SelectedSpendType
    var selectedFilter: FilterType
    
    var filteredTransactions: [TransactionModel] {
        let calendar = Calendar.current
        let filtered = recentTransactions.filter { $0.type == selectedType }

        switch selectedFilter {
        case .all:
            return filtered
        case .daily:
            return filtered.filter { calendar.isDateInToday($0.date) }
        case .weekly:
            return filtered.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) }
        case .monthly:
            return filtered.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .month) }
        case .yearly:
            return filtered.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .year) }
        case .custom(let startDate, let endDate):
            return filtered.filter { transaction in
                transaction.date >= startDate && transaction.date <= endDate
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
                case "Today":
                    return calendar.startOfDay(for: Date()) // Today
                case "Yesterday":
                    return calendar.date(byAdding: .day, value: -1, to: Date()) ?? .distantPast
                default:
                    return DateFormatter.groupedHeader.date(from: key) ?? .distantPast
                }
            }

            return sortDate(for: lhs.key) > sortDate(for: rhs.key) // Descending
        }
    }
 
    
    var body: some View {
        VStack(spacing: 12) {
            // MARK: - List of Filtered Transactions
            ForEach(groupedTransactions, id: \.key) { group in
                VStack(alignment: .leading, spacing: 10) {
                    // Header
                    HStack {
                        Text(group.key)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    // Transactions Group
                    VStack(spacing: 0) {
                        let sortedGroup = group.value.sorted { $0.date > $1.date }
                        ForEach(sortedGroup.indices, id: \.self) { index in
                            let transaction = sortedGroup[index]
                            TransactionRow(transaction: transaction)
                            
                            // Divider between rows
                            if index < sortedGroup.count - 1 {
                                Divider()
                                    .padding(.leading, 56) // aligns with icon
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

    
}

struct RecentTransactionList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecentTransactionList(
                selectedType: .expense, // or .income
                selectedFilter: .all    // or .daily, .weekly, etc.
            )
            .preferredColorScheme(.light)
            
            RecentTransactionList(
                selectedType: .expense,
                selectedFilter: .all
            )
            .preferredColorScheme(.dark)
        }
    }
}

