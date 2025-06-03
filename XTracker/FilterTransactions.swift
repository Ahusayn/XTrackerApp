//
//  FilterTransactions.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//

import SwiftUI
import SwiftData

struct FilterTransactions: View {
    
    @Binding var selectedFilter: FilterType
    @State private var showDatePicker = false
    @State private var customDate: Date? = nil
    @State private var startDate = Date()
    @State private var endDate = Date()


    
    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
    
    @Environment(\.dismiss) var dismiss
   
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(FilterType.allCasesNoCustom, id: \.self) { filter in
                        HStack {
                            Text(filter.title)
                            Spacer()
                            if filter == selectedFilter {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accent)
                            }
                        }
                        .onTapGesture {
                            selectedFilter = filter
                            dismiss()
                        }
                    }
                    
                }
            }
            
            .sheet(isPresented: $showDatePicker) {
                CustomDateFilterPicker(
                    startDate: Binding(
                        get: { startDate },
                        set: { startDate = $0 }
                    ),
                    endDate: Binding(
                        get: { endDate },
                        set: { endDate = $0 }
                    )
                )
                .onDisappear {
                    selectedFilter = .custom(startDate, endDate)
                    dismiss()
                }
            }


            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDatePicker = true
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
        
    }
}

enum FilterType: Equatable, Hashable {
    case all, daily, weekly, monthly, yearly
    case custom(Date, Date) // startDate, endDate

    var title: String {
        switch self {
        case .all: return "All Transactions"
        case .daily: return "Daily Transactions"
        case .weekly: return "Weekly Transactions"
        case .monthly: return "Monthly Transactions"
        case .yearly: return "Yearly Transactions"
        case .custom: return "Custom Range"
        }
    }
}

extension FilterType {
    static var allCasesNoCustom: [FilterType] {
        return [.all, .daily, .weekly, .monthly, .yearly]
    }
}



#Preview {
    FilterTransactions(selectedFilter: .constant(.all))
}

