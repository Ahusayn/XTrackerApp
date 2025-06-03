//
//  XTrackerApp.swift
//  XTracker
//
//  Created by hssn on 09/11/2024.
//

import SwiftUI
import SwiftData

@main
struct XTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TransactionModel.self, Category.self, AccountModel.self, ProfileModel.self, BudgetModel.self])
        }
    }
}

   
