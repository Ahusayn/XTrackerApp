//
//  TransactionsChartView.swift
//  XTracker
//
//  Created by HSSN on 10/01/2025.
//



import SwiftUI
import Charts
import SwiftData

struct TransactionsChartView: View {
    
    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
    
    var selectedType: SelectedSpendType
    
    var selectedFilter: FilterType

    
    let calendar = Calendar.current

    var filteredTransactions: [TransactionModel] {
        let filteredByType = transactions.filter { $0.type == selectedType }
        
        return filteredByType.filter { transaction in
            switch selectedFilter {
            case .daily:
                return calendar.isDateInToday(transaction.date)
            case .weekly:
                return calendar.isDate(transaction.date, equalTo: Date(), toGranularity: .weekOfYear)
            case .monthly:
                return calendar.isDate(transaction.date, equalTo: Date(), toGranularity: .month)
            case .yearly:
                return calendar.isDate(transaction.date, equalTo: Date(), toGranularity: .year)
            case .all:
                return true
            case .custom(let startDate, let endDate):
                return transaction.date >= startDate && transaction.date <= endDate
            }
        }
    }


    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    private let availableYears: [Int] = Array(2000...Calendar.current.component(.year, from: Date()))
    
    
   
    
    // Generate monthly data for the selected year
    var monthlyData: [MonthData] {
        let calendar = Calendar.current
        
        // Step 1: Create a dictionary with all 12 months initialized to 0
        var allMonths: [Int: Double] = (1...12).reduce(into: [:]) { result, month in
            result[month] = 0
        }
        
        // Step 2: Sum transactions by month for the selected year
        for filteredTransaction in filteredTransactions {
            let components = calendar.dateComponents([.year, .month], from: filteredTransaction.date)
            if components.year == selectedYear, let month = components.month {
                allMonths[month, default: 0] += filteredTransaction.amount
            }
        }
        
        // Step 3: Map the dictionary into an array of `MonthData`
        return allMonths
            .sorted { $0.key < $1.key } // Ensure months are in order
            .map { month, totalAmount in
                let date = calendar.date(from: DateComponents(year: selectedYear, month: month)) ?? Date()
                return MonthData(date: date, totalAmount: totalAmount)
            }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
          
            
            // Calculate total amount for all months
            let totalAmount = monthlyData.reduce(0) { $0 + $1.totalAmount }
            
            
            Text(formatAsCurrency(selectedType == .expense ?  totalAmount : totalAmount))
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
            
            Text(selectedType == .expense ? "spent during this period": "earned during this period")
                .font(.footnote)
                .foregroundStyle(Color.gray.opacity(0.9))
                .padding(.bottom, 20)

            
            if !monthlyData.isEmpty {
                Chart(monthlyData) { data in
                    BarMark(
                        x: .value("Month", data.date, unit: .month),
                        y: .value("Amount", data.totalAmount)
                    )
                    .foregroundStyle(Color.text)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .month)) { value in
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date, format: .dateTime.month(.narrow))
                            }
                        }
                    }
                }
                .frame(height: 300)
            } else {
                Text("No data available for the chart.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    

    
    // Function to format the amount based on the user's locale
    func formatAsCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Use the device's locale
        return formatter.string(from: NSNumber(value: amount)) ?? "0.00"
    }

}

struct MonthData: Identifiable {
    let id = UUID()
    let date: Date
    let totalAmount: Double
}

#Preview {
    TransactionsChartView(selectedType: .expense, selectedFilter: .monthly)



}
