//
//  TransactionnPreviewData.swift
//  XTracker
//
//  Created by mac on 28/12/2024.
//

import SwiftUI
import SwiftData

var transactionPreviewData = TransactionModel(comment: "McDonalds", date: Date(), amount: 49.99, selectedCategory: CategoryList.categories.first {$0.name == "Food"}!)

