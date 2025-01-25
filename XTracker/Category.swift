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

    init(name: String, imagename: String, detail: String) {
        self.id = UUID().uuidString
        self.name = name
        self.imagename = imagename
        self.detail = detail
    }
    
    // Equatable conformance
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct CategoryList {
    
    static let categories = [Category(name: "Food", imagename: "food", detail: "Man must chop 🍽️"),
                             Category(name: "Transportation", imagename: "transport", detail: "I can't trek 🚷"),
                             Category(name: "Housing", imagename: "house", detail: "I have to pay rent 🧾"),
                             Category(name: "Utilities", imagename: "bills", detail: "Bills are exhausting ⚡️"),
                             Category(name: "Entertainment", imagename: "netflix", detail: "I need to ball 🍾"),
                             Category(name: "Shopping", imagename: "shopping", detail: "Groceries are life 🍟"),
                             Category(name: "Healthcare", imagename: "health", detail: "Health is Wealth 💰"),
                             Category(name: "Education", imagename: "education", detail: "I need to graduate 🎓"),
                             Category(name: "Vacation", imagename: "vacation", detail: "Make I live my life 🏝️"),
                             Category(name: "Fittness", imagename: "gym", detail: "Fit like a King 👑"),
    
    ]
}
