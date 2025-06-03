//
//  NavigationTabView.swift
//  XTracker
//
//  Created by mac on 08/12/2024.
//

import SwiftUI

struct NavigationTabView: View {
    @State private var inputExpense = false // State variable to control sheet presentation

    var body: some View {
        ZStack {
            Color.black // Background color to fix white area
                .edgesIgnoringSafeArea(.all) // Ignore safe area to cover everything

            TabView {
                // MARK: - Home Page
                HomePage()
                    .tabItem {
                        Label("", systemImage: "clock.fill")
                            .foregroundStyle(Color.text)
                    }

                // MARK: - Transactions Page
                CategorizeTransactions()
                    .tabItem {
                        Label("", systemImage: "chart.pie.fill")
                            .foregroundStyle(Color.text)
                    }

//                // MARK: - Add Expenses Tab
//                Color.clear // Placeholder for Add Expense tab
//                    .onAppear {
//                        inputExpense = true
//                    }
//                    .tabItem {
//                        Label("", systemImage: "plus")
//                    }

                // MARK: - Categories Page
                Account()
                    .tabItem {
                        Label("", systemImage: "square.stack.fill")
                            .foregroundStyle(Color.text)

                    }

                // MARK: - Profile Page
                SettingsPage()
                    .tabItem {
                        Label("", systemImage: "gear")
                            .foregroundStyle(Color.text)

                    }
            }
//            .sheet(isPresented: $inputExpense) {
//                AddExpensesInput()
//                    .background(Color.black.edgesIgnoringSafeArea(.all))
//                   
//            }
            .navigationBarHidden(true) // Hide navigation bar
        }
    }
}

#Preview {
    NavigationTabView()
}
