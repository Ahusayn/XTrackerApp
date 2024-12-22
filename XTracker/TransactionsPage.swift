//
//  TransactionsPage.swift
//  XTracker
//
//  Created by hsan on 21/11/2024.
//

import SwiftUI

struct TransactionsPage: View {
//    @State var selectedTab: Tabs?

    
    var body: some View {
        NavigationView {
            VStack {
                Text("Recent Transactions ")
                Spacer()
//                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TransactionsPage()
    
}
