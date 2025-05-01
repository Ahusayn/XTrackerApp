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
    
    init(id: UUID = UUID(), name: String, imageName: String, balance: Double = 0.0) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.balance = balance
    }
}


struct AccountList {
    
    static let paymentType = [
        AccountModel(name: "Cash", imageName: "cash"),
//        AccountModel(name: "Hssn", imageName: "money")
    ]
}
