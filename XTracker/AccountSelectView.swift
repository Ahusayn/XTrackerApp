//
//  AccountSelectView.swift
//  XTracker
//
//  Created by HSSN on 24/05/2025.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct AccountSelectView: View {
    
    @Environment(\.dismiss) var dismiss
    @Query(sort: \AccountModel.name) var savedaccounts: [AccountModel]
    @Binding var selectedAccount: AccountModel?
    
    var allAccounts: [AccountModel] {
        savedaccounts
    }


    var cashAccount: AccountModel? {
        allAccounts.first(where: {$0.name == "Cash"})
    }

    var body: some View {
        VStack {
            List {
                if allAccounts.isEmpty {
                    Text("No accounts created")
                } else {
                    ForEach(allAccounts, id: \.self) { account in
                        HStack {
                            Text(account.imageName)
                            Text(account.name)
                            Spacer()
                            if account.name == selectedAccount?.name {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedAccount = account
                            dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            if selectedAccount == nil {
                selectedAccount = cashAccount
            }
        }
        .navigationTitle("Accounts")
        .navigationBarTitleDisplayMode(.inline)
    }
}





struct AccountSelectView_Previews: PreviewProvider {
    
    @State static var dummySelected: AccountModel? = AccountModel(name: "Cash", imageName: "cash")
    
    static var previews: some View {
        
        Group {
            AccountSelectView(selectedAccount: $dummySelected)
                .preferredColorScheme(.light)
            
            AccountSelectView(selectedAccount: $dummySelected)
                .preferredColorScheme(.dark)
        }
    }
}
