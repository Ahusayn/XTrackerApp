//
//  CategoryModel.swift
//  XTracker
//
//  Created by mac on 15/12/2024.
//

import SwiftData
import SwiftUI




@Model
class Category: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var imagename: String
    var detail: String
    var type: SelectedSpendType
    var tagHex: String
    
    var tag: Color {
        Color(hex: tagHex)
    }

    init(name: String, imagename: String, detail: String, type: SelectedSpendType, tag: Color) {
        self.id = UUID().uuidString
        self.name = name
        self.imagename = imagename
        self.detail = detail
        self.type = type
        self.tagHex = tag.toHex() ?? "#000000" // Default to black if conversion fails
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum CategoryType: String, Codable {
    case income,  expense
}


struct CategoryList {
    
    static let categories = [Category(name: "Food", imagename: "food", detail: "Man must chop 🍽️", type: .expense, tag: .green),
                             Category(name: "Transport", imagename: "transport", detail: "I can't trek 🚷", type: .expense, tag: .yellow),
                             Category(name: "Housing", imagename: "house", detail: "I have to pay rent 🧾", type: .expense, tag: .orange),
                             Category(name: "Utilities", imagename: "bills", detail: "Bills are exhausting ⚡️", type: .expense, tag: .purple),
                             Category(name: "Entertainment", imagename: "netflix", detail: "I need to ball 🍾", type: .expense, tag: .mint),
                             Category(name: "Shopping", imagename: "shopping", detail: "Groceries are life 🍟", type: .expense, tag: .indigo),
                             Category(name: "Health", imagename: "health", detail: "Health is Wealth 💰", type: .expense, tag: .pink),
                             Category(name: "Education", imagename: "education", detail: "I need to graduate 🎓", type: .expense, tag: .selected),
                             Category(name: "Vacation", imagename: "vacation", detail: "Make I live my life 🏝️", type: .expense, tag: .blue),
                             Category(name: "Fitness", imagename: "gym", detail: "Fit like a King 👑", type: .expense, tag: .teal),
                             Category(name: "Personal", imagename: "Personal", detail: "Stay clean", type: .expense, tag: .yellow),
                             Category(name: "Tax", imagename: "tax", detail: "it pays to pay your tax", type: .expense, tag: .secondary),
                             Category(name: "Tech", imagename: "gadgets", detail: "Tech is life", type: .expense, tag: .cyan ),
                             Category(name: "Charity", imagename: "Charity", detail: "Always give back to the needy", type: .expense, tag: .brown),
                             Category(name: "Repairs", imagename: "Repairs", detail: "Fix it or lose it", type: .expense, tag: .red),
                             Category(name: "Salary", imagename: "Salary", detail: "I just got Pad", type: .income, tag: .green),
                             Category(name: "Investments", imagename: "Investment", detail: "Trade like a King", type: .income, tag: .blue),
                             Category(name: "Business", imagename: "Business", detail: "Side Hustles", type: .income, tag: Color.brown.opacity(0.3))
    
    ]
}



struct CategorySpend: Identifiable {
    let id = UUID()
    let categoryName: String
    let categoryColor: Color
    let totalAmount: Double
    let imagename: String
    let transactions: [TransactionModel]
}


extension CategorySpend {
    init(category: Category, amount: Double, imagename: String, transactions: [TransactionModel]) {
        self.categoryName = category.name
        self.categoryColor = category.tag
        self.totalAmount = amount
        self.imagename = imagename
        self.transactions = transactions
    }
}
