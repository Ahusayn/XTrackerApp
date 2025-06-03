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
    @State private var selectedSide: SelectedSpendType = .expense

    // Filter by income or expense
    var filteredTransactions: [TransactionModel] {
        transactions.filter { $0.type == selectedSide }
    }

    // Group and summarize by category
    var categorySpends: [CategorySpend] {
        let grouped = Dictionary(grouping: filteredTransactions, by: { $0.selectedCategory.name })

        return grouped.compactMap { (categoryName, txns) in
            let total = txns.reduce(0) { $0 + $1.amount }
            guard let matchedCategory = CategoryList.categories.first(where: { $0.name == categoryName }) else {
                return nil
            }
            return CategorySpend(category: matchedCategory, amount: total, imagename: matchedCategory.imagename, transactions: txns)
        }
        .sorted(by: { $0.totalAmount > $1.totalAmount })
    }


    var totalAmount: Double {
        categorySpends.reduce(0) { $0 + $1.totalAmount }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if !categorySpends.isEmpty {
                    ZStack {
                        Chart(categorySpends) { spend in
                            SectorMark(
                                angle: .value("Total", spend.totalAmount),
                                innerRadius: .ratio(0.75), // bigger hole
                                angularInset: 2
                            )
                            .foregroundStyle(spend.categoryColor)
                            .cornerRadius(8)
                        }
                        .frame(height: 250)
                        .padding(.horizontal)
                        .shadow(color: .white.opacity(0.05), radius: 10)


                        if let topSpend = categorySpends.first {
                            VStack(spacing: 6) {
                                Image(topSpend.imagename)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(topSpend.categoryColor)
                                            .opacity(0.2)
                                    )

                                Text(topSpend.totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.title.bold())
                                    .foregroundColor(.primary)

                                Text(topSpend.categoryName.uppercased())
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }

                    }
                    .frame(height: 280)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "banknote")
                            .font(.system(size: 40))
                        Text("No \(selectedSide.rawValue.capitalized) Data")
                            .foregroundColor(Color.primary)
                            .font(.subheadline)
                    }
                    .frame(height: 250)
                }

                Divider().padding(.bottom, 4)

                // Scrollable legend list
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        if !categorySpends.isEmpty {
                            Text("Top Categories")
                                .font(.subheadline)
                                .foregroundStyle(Color.text)
                                .padding(.bottom, 4)
                        }

                        ForEach(categorySpends) { spend in
                            CategoryLegendRow(spend: spend)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $selectedSide) {
                        ForEach(SelectedSpendType.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                    .padding(.top)
                }
            }
        }
    }
}

// MARK: - Legend Row View
struct CategoryLegendRow: View {
    let spend: CategorySpend

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(spend.categoryColor)
                .frame(width: 14, height: 14)

            Text(spend.categoryName)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()

            Text(spend.totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct CategorizeTransactions_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategorizeTransactions()
                .preferredColorScheme(.light)

            CategorizeTransactions()
                .preferredColorScheme(.dark)
        }
    }
}
