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
                        Label("Home", systemImage: "house.fill")
                    }

                // MARK: - Transactions Page
                CategorizeTransactions()
                    .tabItem {
                        Label("Transactions", systemImage: "text.document.fill")
                    }

                // MARK: - Add Expenses Tab
                Color.clear // Placeholder for Add Expense tab
                    .onAppear {
                        inputExpense = true
                    }
                    .tabItem {
                        Label("", systemImage: "plus")
                    }

                // MARK: - Categories Page
                CategoriesPage()
                    .tabItem {
                        Label("Categories", systemImage: "square.stack.fill")
                    }

                // MARK: - Profile Page
                ProfilePage()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
            }
            .sheet(isPresented: $inputExpense) {
                AddExpenses()
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                   
            }
            .navigationBarHidden(true) // Hide navigation bar
        }
    }
}

#Preview {
    NavigationTabView()
}
