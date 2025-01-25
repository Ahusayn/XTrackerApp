//
//  EditandDeleteExpensesView.swift
//  XTracker
//
//  Created by mac on 30/12/2024.
//


import SwiftUI
import SwiftData

struct EditandDeleteExpensesView: View {
    
    var transaction: TransactionModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var title: String
    @State private var desc: String
    @State private var amount: Double
    @State private var selectedCategory: Category
    @State private var date: Date
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
        _title = State(initialValue: transaction.title)
        _desc = State(initialValue: transaction.desc)
        _amount = State(initialValue: transaction.amount)
        _selectedCategory = State(initialValue: transaction.selectedCategory)
        _date = State(initialValue: transaction.date)
    }
    
    var categories: [Category] = CategoryList.categories
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Title") {
                        TextField("", text: $title)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Section("Description") {
                        TextField("", text: $desc)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Section("Amount") {
                        TextField("", value: $amount, formatter: NumberFormatter.currency)
                            .multilineTextAlignment(.leading)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section("Choose Category") {
                        Picker("Select a Category", selection: $selectedCategory) {
                            ForEach(categories) { category in
                                Text(category.name)
                                    .tag(category)
                                    .font(.headline)
                                    .foregroundColor(Color.text)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section("Date") {
                        DatePicker("", selection: $date, displayedComponents: [.date])
                            .datePickerStyle(.automatic)
                            .labelsHidden()
                    }
                }
                

               
            }
            
        

            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Delete logic
                        context.delete(transaction)
                        
                        do {
                            try context.save()
                            print("Transaction deleted successfully")
                        } catch {
                            print("Error deleting transaction: \(error.localizedDescription)")
                        }
                        
                        dismiss()
                    }) {
                        Image(systemName: "trash")
                            .font(.body)
                    }
                    .font(.headline)
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 5)
                    
                }
                
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Text("Transactions")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(Color.text)
//                }
//                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Save logic
                        transaction.title = title
                        transaction.desc = desc
                        transaction.amount = amount
                        transaction.selectedCategory = selectedCategory
                        transaction.date = date

                        do {
                            try context.save()
                            print("Transaction Updated Successfully: \(transaction)")
                        } catch {
                            print("Error updating transaction \(error.localizedDescription)")
                        }

                        dismiss()
                    }
                    ) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(Color.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.button)
                            .cornerRadius(10)
                    }
                   
                }
            }
        }
    }
}

struct EditandDeleteExpensesView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            
            EditandDeleteExpensesView(transaction: transactionPreviewData)
                .preferredColorScheme(.light)
            
            EditandDeleteExpensesView(transaction: transactionPreviewData)
                .preferredColorScheme(.dark)
        }
    }
   
    
}
