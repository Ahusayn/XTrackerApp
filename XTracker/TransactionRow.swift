//
//  TransactionRow.swift
//  XTracker
//
//  Created by mac on 25/12/2024.
//

import SwiftUI

struct TransactionRow: View {
    var transaction: TransactionModel
    @State private var showEditandDelete = false
    
    var body: some View {
        HStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.button.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(transaction.selectedCategory.imagename)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                }
            
            VStack(alignment: .leading, spacing: 5) {
                //MARK: - Transaction Merchant
                Text(transaction.title)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                //MARK: - Transaction Category
                Text(transaction.selectedCategory.name)
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                
                //MARK: - Transaction Date
                Text(transaction.date, format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
            
            
            }
            Spacer()
             
            //MARK: - Transaction Amount
            Text(-transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .bold()
                .foregroundColor(Color.red)
            
        }
        
        .onTapGesture {
            showEditandDelete = true
        }
        
        .sheet(isPresented: $showEditandDelete) {
            EditandDeleteExpensesView(transaction: transaction)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
        }
        
        
        .padding([.top, .bottom], 8)
        
    }
}

#Preview {
    
    TransactionRow(transaction: transactionPreviewData)
}
