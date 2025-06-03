//
//  TransactionDashboard.swift
//  XTracker
//
//  Created by HSSN on 28/05/2025.
//

import SwiftUI

struct TransactionsDashboard: View {
    @Binding var selectedFilter: FilterType
    @Binding var selectedType: SelectedSpendType

 

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    TransactionsChartView(
                        selectedType: selectedType,
                        selectedFilter: selectedFilter
                    )

                    RecentTransactionList(
                        selectedType: selectedType,
                        selectedFilter: selectedFilter
                    )
                }
                .padding()
            }
          
           
            
        }
    }
}



    #Preview {
        TransactionsDashboard(
            selectedFilter: .constant(.all),
            selectedType: .constant(.expense)
        )
    }


