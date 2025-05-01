////
////  CategorizeTransactions.swift
////  XTracker
////
////  Created by mac on 02/01/2025.
////
//
//import SwiftUI
//import Charts
//import SwiftData
//
//struct CategorizeTransactions: View {
//    
//    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
//    
//    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
//    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
//    
//    private let availableYears: [Int] = Array(2000...Calendar.current.component(.year, from: Date()))
//    private let availableMonths: [Int] = Array(1...12)
//    
//    var filteredTransactions: [TransactionModel] {
//        transactions.filter { transaction in
//            let components = Calendar.current.dateComponents([.year, .month], from: transaction.date)
//            return components.year == selectedYear && components.month == selectedMonth
//        }
//    }
//    
//    var groupedTransactions: [String: [TransactionModel]] {
//        let filtered = filteredTransactions
//        return Dictionary(grouping: filtered) { transaction in
//            transaction.selectedCategory.name
//        }
//    }
//    
//    var categoryTotals: [String: Double] {
//        groupedTransactions.mapValues { transactions in
//            transactions.reduce(0) { $0 + $1.amount }
//        }
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 25) {
//                // Year and Month Picker
//                HStack {
//                    Text("Year:")
//                        .font(.headline)
//                    
//                    Picker("Select Year", selection: $selectedYear) {
//                        ForEach(availableYears, id: \.self) { year in
//                            Text(year.description)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    
//                    Text("Month:")
//                        .font(.headline)
//                    
//                    Picker("Select Month", selection: $selectedMonth) {
//                        ForEach(availableMonths, id: \.self) { month in
//                            Text("\(month)")
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                }
//                .padding()
//                
//                if !filteredTransactions.isEmpty {
//                    VStack(spacing: 20) {
//                        // Pie Chart
//                        Chart {
//                            ForEach(categoryTotals.sorted(by: { $0.key < $1.key }), id: \.key) { category, total in
//                                SectorMark(
//                                    angle: .value("Total", total),
//                                    innerRadius: .ratio(0.5),
//                                    outerRadius: .ratio(0.9)
//                                )
//                                .foregroundStyle(by: .value("Category", category))
//                            }
//                        }
//                        .frame(height: 300)
//                        .padding()
//                    }
//                    
//                    // List of Categories and Totals
//                    List {
//                        ForEach(Array(groupedTransactions.keys.sorted()), id: \.self) { category in
//                            if let transactions = groupedTransactions[category] {
//                                Section(header: Text(category)) {
//                                    ForEach(transactions, id: \.id) { transaction in
//                                        VStack(alignment: .leading) {
//                                            Text(transaction.title)
//                                                .font(.headline)
//                                            Text(transaction.comment)
//                                                .font(.subheadline)
//                                            Text(formatAsCurrency(transaction.amount))
//                                                .font(.footnote)
//                                                .foregroundColor(.red)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    // No transactions for selected year and month
//                    VStack(spacing: 25) {
//                        Image(systemName: "banknote")
//                            .font(.system(size: 30))
//                        Text("No transactions for this month!")
//                            .font(.headline)
//                            .foregroundColor(Color.primary)
//                        Text("Add Transactions by tapping the + button below")
//                            .font(.subheadline)
//                            .foregroundColor(Color.primary)
//                    }
//                    .multilineTextAlignment(.center)
//                }
//            }
//            .padding()
//            .navigationTitle("Transaction Summary")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//    
//    // Format amount to currency
//    func formatAsCurrency(_ amount: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale.current
//        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
//    }
//}
//
//#Preview {
//    CategorizeTransactions()
//}
