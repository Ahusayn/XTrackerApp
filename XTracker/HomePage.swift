//
//  HomePage.swift
//  XTracker
//
//  Created by hssn on 12/11/2024.
//


import SwiftUI
import SwiftData
import Charts

struct HomePage: View {
    
    @Environment(\.modelContext) var context
    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
    
    @Query(sort: \ProfileModel.firstName) var profile: [ProfileModel]
    
    

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    if !transactions.isEmpty {
                        //MARK: - Charts
                        TransactionsChartView()
                        //MARK: - RecentTransaction List
                        RecentTransactionList()
                    }
                    else {
                        Spacer(minLength: 200)
                        
                        VStack(spacing: 25) {
                            Image(systemName: "banknote")
                                .font(.system(size: 30))
                            Text("You have no expenses this month!")
                                .font(.headline)
                                .foregroundColor(Color.primary)
                            Text("Add Transactions by tapping the + button below")
                                .font(.subheadline)
                                .foregroundColor(Color.primary)
                        }
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                   

                }
            }
        
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if let userProfile = profile.first {
                               Text("✌🏿 Hey \(userProfile.firstName)!")
                                   .font(.title2)
                           } else {
                               Text("✌🏿 Hey!")
                                   .font(.title2)
                           }

                }

                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AudioExpenseAdderView()) {
                            Image(systemName: "mic.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    
                    // Bell badge icon
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
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
