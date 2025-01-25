//
//  Extensions.swift
//  XTracker
//
//  Created by hssn on 09/11/2024.
//

import SwiftUI

extension Color {
    static let backgroundcolor = Color("Background")
    static let texts = Color("Text")
    static let buttonColor = Color("Button")
    static let selectedtab = Color("Selected")
}

extension DateFormatter {
    static let numericUSA: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}


extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.numericUSA.date(from: self) else { return Date() }
        
        return parsedDate
    }
}

extension Date: Strideable {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
}

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
}


