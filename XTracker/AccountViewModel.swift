////
////  AccountViewModel.swift
////  XTracker
////
////  Created by HSSN on 23/05/2025.
////
//
//import Foundation
//import SwiftUI
//
//class AccountViewModel: ObservableObject {
//    
//    @Published var selectedAccount: AccountModel?
//    @Published var transactions: [TransactionModel] = []
//    
//    init(defaultAccount: AccountModel?, transactions: [TransactionModel]) {
//            self.selectedAccount = defaultAccount
//            self.transactions = transactions
//    }
//    
//    var filteredTransactions: [TransactionModel] {
//        guard let selected = selectedAccount else { return [] }
//        return transactions.filter {
//            if selected.name == "Cash" {
//                return $0.paymentType == "Cash"
//            } else {
//                return $0.account?.id == selected.id
//            }
//        }
//    }
//    
//}
