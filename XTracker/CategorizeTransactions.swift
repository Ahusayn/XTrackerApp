//
//  CategorizeTransactions.swift
//  XTracker
//
//  Created by mac on 02/01/2025.
//

import SwiftUI
import Charts
import SwiftData

struct CategorizeTransactions: View {
    
    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
    
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private let availableYears: [Int] = Array(2000...Calendar.current.component(.year, from: Date()))
    private let availableMonths: [Int] = Array(1...12)
    
    var filteredTransactions: [TransactionModel] {
        transactions.filter { transaction in
            let components = Calendar.current.dateComponents([.year, .month], from: transaction.date)
            return components.year == selectedYear && components.month == selectedMonth
        }
    }
    
    var groupedTransactions: [String: [TransactionModel]] {
        Dictionary(grouping: filteredTransactions, by: { $0.selectedCategory.name })
    }
    
    var categoryTotals: [String: Double] {
        groupedTransactions.mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Year and Month Picker
                HStack {
                    Text("Year:")
                        .font(.headline)
                    
                    Picker("Select Year", selection: $selectedYear) {
                        ForEach(availableYears, id: \.self) { year in
                            Text(year.description)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Text("Month:")
                        .font(.headline)
                    
                    Picker("Select Month", selection: $selectedMonth) {
                        ForEach(availableMonths, id: \.self) { month in
                            Text("\(month)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()
                
                // Show Pie Chart based on selected year and month
                if !filteredTransactions.isEmpty {
                    VStack(spacing: 20) {
                        // Pie Chart
                        Chart {
                            ForEach(categoryTotals.keys.sorted(), id: \.self) { category in
                                if let total = categoryTotals[category] {
                                    SectorMark(
                                        angle: .value("Total", total),
                                        innerRadius: .ratio(0.5),
                                        outerRadius: .ratio(0.9)
                                    )
                                    .foregroundStyle(by: .value("Category", category))
                                    
                                }
                            }
                        }
                        .frame(height: 300)
                        .padding()
                    }
                    
                    // List of Categories and Totals
                    List {
                        ForEach(Array(groupedTransactions.keys.sorted()), id: \.self) { category in
                            if let transactions = groupedTransactions[category] {
                                Section(header: Text(category)) {
                                    ForEach(transactions, id: \.id) { transaction in
                                        VStack(alignment: .leading) {
                                            Text(transaction.title)
                                                .font(.headline)
                                            Text(transaction.desc)
                                                .font(.subheadline)
                                            Text(formatAsCurrency(transaction.amount))
                                                .font(.footnote)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // No transactions for selected year and month
                    VStack(spacing: 25) {
                        Image(systemName: "banknote")
                            .font(.system(size: 30))
                        Text("No transactions for this month!")
                            .font(.headline)
                            .foregroundColor(Color.primary)
                        Text("Add Transactions by tapping the + button below")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                    }
                    .multilineTextAlignment(.center)
                }
            }
            .padding()
            .navigationTitle("Transaction Summary")
            .navigationBarTitleDisplayMode(.inline)
           
        }
        
        }
    
    // Function to format the amount based on the user's locale
    func formatAsCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Use the device's locale
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }
}

#Preview {
    CategorizeTransactions()
}
