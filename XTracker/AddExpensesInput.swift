////
////  AddExpenses.swift
////  XTracker
////
////  Created by hssn on 08/12/2024.
////
//
//import SwiftUI
//import SwiftData
//
//struct AddExpensesInput: View {
//    
//    @Environment(\.modelContext) var context
//    @Environment(\.dismiss) private var dismiss
//    
//    @State private var title: String = ""
//    @State private var desc: String = ""
//    @State private var amount: Double = 0
//    @State private var selectedCategory: Category = CategoryList.categories.first ?? Category(name: "Default", imagename: "default", detail: "Default category", type: .expense)
//    
//    @State private var isHomePage = false
//
//    @State private var date: Date = .now
//    
//    @State private var inputExpense = false
//
//    var categories: [Category] = CategoryList.categories
//    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Form {
//                    Section("Title") {
//                        TextField("Iphone 15", text: $title)
//                    }
//                    
//                    Section("Description") {
//                        TextField("Spectacular", text: $desc)
//                    }
//                    
//                    Section("Amount") {
//                        TextField("Amount 💰", value: $amount, formatter: NumberFormatter.currency)
//                            .keyboardType(.decimalPad)
//                    }
//
//                    
//                    Section("Category") {
//                        Picker("Select Category", selection: $selectedCategory) {
//                            ForEach(categories) { category in
//                                Text(category.name).tag(category) .font(.headline)
//                                    .foregroundColor(Color.text)
//                            }
//                        }
//                    }
//                    
//                    Section("Date") {
//                        DatePicker("", selection: $date, displayedComponents: [.date])
//                            .datePickerStyle(.graphical)
//                            .labelsHidden()
//                    }
//
//                }
//                .fullScreenCover(isPresented: $isHomePage) {
//                    HomePage()
//                }
//                .navigationTitle("Add Expenses")
//                .navigationBarTitleDisplayMode(.inline)
//                
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button("Cancel") {
//                            dismiss()
//                        }
//                        .tint(.red)
//                    }
//                    
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button("Save") {
//                            let transaction = TransactionModel(
//                                title: title,
//                                desc: desc,
//                                date: date,
//                                amount: amount,
//                                selectedCategory: selectedCategory
//                                
//                            )
//                            
//                            context.insert(transaction)
//                         
//                            
//                            do {
//                                try context.save()
//                                print("Transaction saved successfully: \(transaction)")
//                                dismiss()
//                            } catch {
//                                print("Error saving transaction: \(error)")
//                            }
//
//                            dismiss()
//                        }
//                        .tint(.blue)
//                    }
//                }
//            }
//        }
//        
//    }
//}
//
//struct AddExpenses_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            AddExpensesInput()
//                .preferredColorScheme(.light)
//            
//            AddExpensesInput()
//                .preferredColorScheme(.dark)
//        }
//    }
//}
