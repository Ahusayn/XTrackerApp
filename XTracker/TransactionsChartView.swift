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
        for transaction in transactions {
            let components = calendar.dateComponents([.year, .month], from: transaction.date)
            if components.year == selectedYear, let month = components.month {
                allMonths[month, default: 0] += transaction.amount
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
        VStack(alignment: .leading) {
            
            // Year Picker
            HStack {
                Text("Year:")
                    .font(.headline)
                
                Picker("Select Year", selection: $selectedYear) {
                    ForEach(availableYears, id: \.self) { year in
                        Text(year.description)
                           
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.bottom, 10)
            
            // Calculate total amount for all months
            let totalAmount = monthlyData.reduce(0) { $0 + $1.totalAmount }
            
            Text(formatAsCurrency(-totalAmount))
                .font(.title2)
                .bold()
                .padding(.bottom, 10)

            
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
    TransactionsChartView()
}
