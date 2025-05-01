//
//  AccountIcons.swift
//  XTracker
//
//  Created by HSSN on 27/03/2025.
//

import SwiftUI
import SwiftData

struct AccountIcons: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    var accounts: [AccountModel] = AccountList.paymentType
    @Binding var selectedAccounts: AccountModel
    let columns =  [ GridItem(.adaptive(minimum: 90), spacing: 30)
        
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    if !accounts.isEmpty {
                        ForEach(accounts, id: \.self) { account in
                            HStack {
                                Button {
                                    selectedAccounts = account
                                    dismiss()
                                    
                                } label: {
                                    VStack(spacing: 12) {
                                        Image(account.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                        Text(account.name)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.text)
                                    }
                                }
                            }
                            
                        }
                        
                        if accounts.count == 1 && accounts.first?.name == "Cash" {
                            HStack {
                                Button {
                                    
                                } label: {
                                    VStack(spacing: 12) {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color.text)
                                        Text("Add")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Color.text)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            Text("Add")
                                .foregroundStyle(Color.text)
                                .font(.system(size: 15, weight: .medium))
                            
                        }
                    }
                   
                }
                .padding()
                    
                            
                            

                }
                .navigationTitle("Accounts")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    
      
    }





struct AccountIcons_Previews: PreviewProvider {
    
    @State static private var previewAccounts = AccountList.paymentType.first!
    
    static var previews: some View {
        
            
            AccountIcons(selectedAccounts: $previewAccounts)
                .preferredColorScheme(.light)
            
          
    }
    
}


//#Preview {
//    AccountIcons()
//}
