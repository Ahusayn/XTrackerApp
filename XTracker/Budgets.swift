//
//  Budgets.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//

import SwiftUI
import SwiftData

struct Budgets: View {
    @State private var isAddBudget = false
    @Query var transactions: [TransactionModel]
    @Query var budgets: [BudgetModel]
    
    func spentAmount(for budget: BudgetModel) -> Double {
        transactions
            .filter { $0.selectedCategory == budget.category }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    // Optionally show all budgets, or filter by overspent
    var displayedBudgets: [BudgetModel] {
        budgets
        // budgets.filter { spentAmount(for: $0) >= $0.amount }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                    ForEach(displayedBudgets, id: \.id) { budget in
                        let spent = spentAmount(for: budget)
                        let progress = min(1.0, spent / budget.amount)
                        
                        HStack(spacing: 16) {
                            Image(budget.category.imagename)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(budget.category.tag.opacity(0.2))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(budget.category.name)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                
                                ProgressView(value: progress)
                                    .accentColor(progress >= 1 ? .red : .green)
                                    .frame(height: 8)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                
                             
                                Text(spent <= budget.amount
                                     ? "\(spent.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))) out of \(budget.amount.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))"
                                     : "Overspent: \(spent.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))) out of \(budget.amount.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))")


                                    .font(.caption)
                                    .foregroundColor(progress >= 1 ? .red : .secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.systemGray6))
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Budgets")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isAddBudget) {
                AddBudget()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddBudget = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
}



#Preview {
    Budgets()
}
