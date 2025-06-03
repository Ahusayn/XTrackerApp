//
//  Extensions.swift
//  XTracker
//
//  Created by hssn on 09/11/2024.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
            let scanner = Scanner(string: hex)
            _ = scanner.scanString("#")

            var rgb: UInt64 = 0
            scanner.scanHexInt64(&rgb)

            let r = Double((rgb >> 16) & 0xFF) / 255.0
            let g = Double((rgb >> 8) & 0xFF) / 255.0
            let b = Double(rgb & 0xFF) / 255.0

            self.init(red: r, green: g, blue: b)
        }

        func toHex() -> String? {
            let uiColor = UIColor(self)
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

            guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
                return nil
            }

            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    
    
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

    static let groupedHeader: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Change from .abbreviated to .medium
        formatter.timeStyle = .none
        return formatter
    }()
}


extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.numericUSA.date(from: self) else { return Date() }
        return parsedDate
    }

    var containsOnlyEmoji: Bool {
        // Checks all characters, not just scalars
        return !isEmpty && allSatisfy { $0.isEmoji }
    }
    
    
}

extension Character {
    var isEmoji: Bool {
        // More reliable emoji detection
        return unicodeScalars.first?.properties.isEmoji == true
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




