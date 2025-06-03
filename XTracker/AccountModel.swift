//
//  PaymentType.swift
//  XTracker
//
//  Created by HSSN on 22/04/2025.
//
import Foundation
import SwiftData

@Model
class AccountModel: Identifiable {
    var id: UUID
    var name: String
    var imageName: String
    var balance: Double
    var income:  Double
    var expense: Double
    
    init(id: UUID = UUID(), name: String, imageName: String, balance: Double = 0.0, income: Double = 0.0, expense: Double = 0.0) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.balance = balance
        self.income = income
        self.expense = expense
    }
    
    func addIncome(_ amount: Double) {
        income += amount
        balance += amount
        print("addIncome called: +\(amount) | income: \(income) | balance: \(balance)")
    }

    func removeIncome(_ amount: Double) {
        income -= amount
        balance -= amount
        print("removeIncome called: -\(amount) | income: \(income) | balance: \(balance)")
    }

    func addExpense(_ amount: Double) {
        expense += amount
        balance -= amount
        print("addExpense called: +\(amount) | expense: \(expense) | balance: \(balance)")
    }

    func removeExpense(_ amount: Double) {
        expense -= amount
        balance += amount
        print("removeExpense called: -\(amount) | expense: \(expense) | balance: \(balance)")
    }
    
    func updateTransaction(oldAmount: Double, oldIsIncome: Bool, newAmount: Double, newIsIncome: Bool) {
        if oldIsIncome {
            income -= oldAmount
            balance -= oldAmount
        } else {
            expense -= oldAmount
            balance += oldAmount
        }

        if newIsIncome {
            income += newAmount
            balance += newAmount
        } else {
            expense += newAmount
            balance -= newAmount
        }
    }
    
   


}

struct AccountList {
    
    static let paymentType = [
        AccountModel(name: "Cash", imageName: "cash"),
//        AccountModel(name: "Hssn", imageName: "money")
    ]
}


