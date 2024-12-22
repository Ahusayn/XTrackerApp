//
//  HomePage.swift
//  XTracker
//
//  Created by hssn on 12/11/2024.
//


import SwiftUI
import SwiftData

struct HomePage: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Transaction.date) var transactions: [Transaction]

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Spacer()
                
                if !transactions.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(transactions) { transaction in
                            VStack(alignment: .leading) {
                                Text(transaction.title)
                                    .font(.headline)
                                Text(transaction.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("$\(transaction.amount, specifier: "%.2f")")
                                    .font(.body)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                } else {
                    Image(systemName: "banknote")
                        .font(.system(size: 30))
                    Text("You have no expenses this month!")
                        .font(.headline)
                        .foregroundColor(Color.primary)
                    Text("Add Transactions by tapping the + button below")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                }
                
                Spacer()
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("✌🏿 Hey Abdul!")
                        .font(.title2)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.primary)
                        
                        Image(systemName: "bell.badge")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.primary)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .accentColor(.primary)
        .onAppear {
            print("Number of transactions: \(transactions.count)")
            transactions.forEach { print($0) }
        }

    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomePage()
                .preferredColorScheme(.light)
            
            HomePage()
                .preferredColorScheme(.dark)
        }
    }
}
