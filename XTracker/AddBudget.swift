//
//  AddBudget.swift
//  XTracker
//
//  Created by HSSN on 28/05/2025.
//

import SwiftUI

struct AddBudget: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var amount = "0"
    var caegory: [Category] = CategoryList.categories
    @State private var selectedCategory: Category = CategoryList.categories.first!
    @State private var isCategoryIcons = false
    
    var formattedAmount: String {
        let currencySymbol = Locale.current.currencySymbol ?? "₺"
        return amount.isEmpty ? "\(currencySymbol)0" : "\(currencySymbol)\(amount)"
    }
    
   
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Button {
                        isCategoryIcons = true
                    } label: {
                        Image(selectedCategory.imagename)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(selectedCategory.name)
                            .bold()
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: 80)
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(8)
                }
                .padding()
                
                Spacer()
                
                VStack {
                    Text(formattedAmount)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxHeight: 60)
                    
                    Text("Set Budgets, Spend Wisely..")
                        .foregroundStyle(Color.text)
                        .font(.subheadline)

                    
                }
                .padding()
                
                CustomKeypadBudget(amount: $amount)
           
                
            }
            
            .sheet(isPresented: $isCategoryIcons) {
                CategoryIcons(fixedType: .expense, selectedCategory: $selectedCategory)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let amountValue = Double(amount) {
                            let newBudget = BudgetModel(amount: amountValue, category: selectedCategory)
                            context.insert(newBudget)
                            do {
                                try context.save()
                                print("New budget for: \(newBudget.category)")
                                dismiss()
                            } catch {
                                print("Error saving budget: \(error.localizedDescription)")
                            }
                        } else {
                            print("Invalid amount entered.")
                        }

                    } label: {
                        Text("Save")
                            
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                      dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            
                    }
                }
            }
            .padding(.bottom, 0)
            
            
        }
      
        
    }
}

#Preview {
    AddBudget()
}
