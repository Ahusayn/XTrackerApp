//
//  TransactionnPreviewData.swift
//  XTracker
//
//  Created by mac on 28/12/2024.
//

import SwiftUI
import SwiftData

var transactionPreviewData = TransactionModel(title: "Balling", desc: "Trip to bursa", date: Date()
                                              , amount: 500.50, selectedCategory: CategoryList.categories.first {$0.name == "Vacation"}!)

