//
//  AudioExpenseAdderView.swift
//  XTracker
//
//  Created by HSSN on 16/01/2025.
//


import SwiftData
import SwiftUI

// Custom Error Wrapper to handle alerts
struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

struct AudioExpenseAdderView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = AudioExpenseAdderViewModel()
    @State private var errorMessage: ErrorWrapper? // To show error messages
    @State private var isProcessing = false // To show a loading indicator during processing

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Microphone Icon
                Image(systemName: "mic.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(viewModel.isRecording ? .red : .blue)
                    .onTapGesture {
                        if viewModel.isRecording {
                            viewModel.stopRecording()
                        } else {
                            viewModel.startRecording()
                        }
                    }

                // Recognized Text or Instruction
                if isProcessing {
                    ProgressView("Processing your input...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    VStack {
                        Text(viewModel.recognizedText.isEmpty ? "Tap the mic to start recording" : viewModel.recognizedText)
                            .font(.headline)
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    
                }

                // Add Expense Button
                    Button(action: parseExpense) {
                        Text("Add Expense")
                            .font(.headline)
                            .padding()
                            .frame(width: .infinity, height: .infinity)
                            .background(Color.brown.opacity(0.5))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                        
                    }
                    .disabled(viewModel.recognizedText.isEmpty || isProcessing)
                
               
            }
            .padding()
            .alert(item: $errorMessage) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // Parse Expense from Recognized Text
    func parseExpense() {
        guard !viewModel.recognizedText.isEmpty else {
            errorMessage = ErrorWrapper(message: "No text recognized. Please try again.")
            return
        }

        isProcessing = true // Start processing
        let text = viewModel.recognizedText.lowercased()
        var expenseTitle = "Unknown Expense"
        var expenseAmount: Double = 0.0
        var expenseCategory = "Uncategorized"
        var expenseDate: Date? = Date()

        // Predefined category keywords
        let categoryKeywords: [String: [String]] = [
            "Education": ["school", "fees", "tuition", "education"],
            "Food": ["grocery", "food", "restaurant", "meal", "dinner", "lunch"],
            "Housing": ["rent", "apartment", "house", "mortgage"],
            "Transportation": ["transport", "fuel", "bus", "train", "gas"],
            "Entertainment": ["movie", "cinema", "concert", "entertainment", "watched"],
            "Shopping": ["watch", "jewelry", "luxury", "accessories", "gold"]
        ]

        // Extract the amount using regex and handle commas
        let amountRegex = "[\\$€₹]?[0-9]{1,3}(?:,[0-9]{3})*(?:\\.[0-9]{1,2})?"
        if let amountMatch = text.range(of: amountRegex, options: .regularExpression) {
            let amountStr = String(text[amountMatch])
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: "€", with: "")
                .replacingOccurrences(of: "₹", with: "")
                .replacingOccurrences(of: ",", with: "") // Remove commas
            expenseAmount = Double(amountStr) ?? 0.0
        }

        // Validate amount
        if expenseAmount == 0.0 {
            errorMessage = ErrorWrapper(message: "Unable to detect an amount in the recognized text.")
            isProcessing = false
            return
        }

        // Extract category based on keywords
        for (category, keywords) in categoryKeywords {
            if keywords.contains(where: { text.contains($0) }) {
                expenseCategory = category
                break
            }
        }

        // Validate category
        if expenseCategory == "Uncategorized" {
            errorMessage = ErrorWrapper(message: "Unable to determine a category. Please try again.")
            isProcessing = false
            return
        }

        // Extract title by removing recognized amount and category words
        expenseTitle = text
            .replacingOccurrences(of: amountRegex, with: "", options: .regularExpression)
            .replacingOccurrences(of: expenseCategory.lowercased(), with: "", options: .caseInsensitive)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized

        // Extract date based on "on <date>" or default to today
        if let onIndex = text.split(separator: " ").firstIndex(of: "on") {
            let dateStr = text.split(separator: " ").suffix(from: onIndex + 1).joined(separator: " ")
            if let date = parseDate(dateStr) {
                expenseDate = date
            }
        }

        // Match to existing categories or default
        let selectedCategory = CategoryList.categories.first { $0.name.lowercased() == expenseCategory.lowercased() } ?? CategoryList.categories.first!

////        let transaction = TransactionModel(
////            comment: expenseComment,
////            desc: expenseCategory,
////            date: expenseDate ?? Date(),
////            amount: expenseAmount,
////            selectedCategory: selectedCategory
////        )
//
//        saveTransaction(transaction)
    }

    // Date Parsing Function
    func parseDate(_ dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        let formats = ["yyyy-MM-dd", "MM/dd/yyyy", "MMM dd, yyyy", "MMMM dd, yyyy"]
        
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateStr) {
                return date
            }
        }

        // Handle relative dates
        if dateStr.lowercased().contains("yesterday") {
            return Calendar.current.date(byAdding: .day, value: -1, to: Date())
        } else if dateStr.lowercased().contains("last week") {
            return Calendar.current.date(byAdding: .day, value: -7, to: Date())
        }

        return nil
    }

    // Save Transaction to Context
    func saveTransaction(_ transaction: TransactionModel) {
        do {
            context.insert(transaction)  // Insert the transaction into the context
            try context.save()  // Explicitly save the context
            print("Transaction saved successfully")
            isProcessing = false
            dismiss()
        } catch {
            errorMessage = ErrorWrapper(message: "Error saving transaction: \(error.localizedDescription)")
            isProcessing = false
        }
    }
}

struct AudioExpenseAdderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AudioExpenseAdderView()
                .preferredColorScheme(.light)
            
            AudioExpenseAdderView()
                .preferredColorScheme(.dark)
        }
    }
}

