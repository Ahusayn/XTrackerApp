////
////  dummyData.swift
////  XTracker
////
////  Created by HSSN on 03/05/2025.
////
//
//import Foundation
//
//import SwiftData
//
//func addDummyTransactionsIfNeeded(context: ModelContext) async {
//    let transactionFetch = FetchDescriptor<TransactionModel>()
//    let existing = try? context.fetch(transactionFetch)
//
//    guard existing?.isEmpty ?? true else { return }
//
//    // Insert sample categories
//    let food = Category(name: "Food", imagename: "food", detail: "Man must chop 🍽️", type: .expense)
//    let salary = Category(name: "Salary", imagename: "Salary", detail: "I just got Pad", type: .income)
//    let transport = Category(name: "Transport", imagename: "transport", detail: "I can't trek 🚷", type: .expense)
//
//    // Insert a sample account
//    let bank = AccountModel(name: "My Bank", imageName: "bank", balance: 1000.0)
//
//    context.insert(food)
//    context.insert(salary)
//    context.insert(transport)
//    context.insert(bank)
//
//    // Insert dummy transactions
//    let dummyTransactions = [
//        TransactionModel(comment: "Lunch", date: .now, amount: 12.0, selectedCategory: food),
//        TransactionModel(comment: "Salary Received", date: .now.addingTimeInterval(-86400 * 2), amount: 2500.0, selectedCategory: salary, paymentType: "Account", account: bank),
//        TransactionModel(comment: "Bus Fare", date: .now.addingTimeInterval(-86400), amount: 4.5, selectedCategory: transport)
//    ]
//
//    dummyTransactions.forEach { context.insert($0) }
//
//    try? context.save()
//}
