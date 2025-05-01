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

    init(name: String, imagename: String, detail: String, type: SelectedSpendType) {
        self.id = UUID().uuidString
        self.name = name
        self.imagename = imagename
        self.detail = detail
        self.type = type
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
    
    static let categories = [Category(name: "Food", imagename: "food", detail: "Man must chop 🍽️", type: .expense),
                             Category(name: "Transport", imagename: "transport", detail: "I can't trek 🚷", type: .expense),
                             Category(name: "Housing", imagename: "house", detail: "I have to pay rent 🧾", type: .expense),
                             Category(name: "Utilities", imagename: "bills", detail: "Bills are exhausting ⚡️", type: .expense),
                             Category(name: "Entertainment", imagename: "netflix", detail: "I need to ball 🍾", type: .expense),
                             Category(name: "Shopping", imagename: "shopping", detail: "Groceries are life 🍟", type: .expense),
                             Category(name: "Health", imagename: "health", detail: "Health is Wealth 💰", type: .expense),
                             Category(name: "Education", imagename: "education", detail: "I need to graduate 🎓", type: .expense),
                             Category(name: "Vacation", imagename: "vacation", detail: "Make I live my life 🏝️", type: .expense),
                             Category(name: "Fitness", imagename: "gym", detail: "Fit like a King 👑", type: .expense),
                             Category(name: "Personal", imagename: "Personal", detail: "Stay clean", type: .expense),
                             Category(name: "Tax", imagename: "tax", detail: "it pays to pay your tax", type: .expense),
                             Category(name: "Tech", imagename: "gadgets", detail: "Tech is life", type: .expense),
                             Category(name: "Charity", imagename: "Charity", detail: "Always give back to the needy", type: .expense),
                             Category(name: "Repairs", imagename: "Repairs", detail: "Fix it or lose it", type: .expense),
                             Category(name: "Salary", imagename: "Salary", detail: "I just got Pad", type: .income),
                             Category(name: "Investments", imagename: "Investment", detail: "Trade like a King", type: .income),
                             Category(name: "Business", imagename: "Business", detail: "Side Hustles", type: .income)
    
    ]
}
