//
//  CreateAccounts.swift
//  XTracker
//
//  Created by HSSN on 17/05/2025.
//



import SwiftUI
import SwiftData

struct CreateAccounts: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    
    
    @State private var name: String = ""
    @State private var emojiText: String = ""
    @State private var balance: Double = 0.0
    @State private var emojiIsFocused = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        VStack(spacing: 16) {
                            Button {
                                emojiIsFocused = true // Show emoji keyboard
                            } label: {
                                Text(emojiText.isEmpty ? "😀" : emojiText)
                                    .font(.system(size: 60))
                                    .frame(width: 80, height: 80)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.gray.opacity(0.5))
                                    )
                            }

                            // Hidden emoji text field
                            EmojiTextField(text: $emojiText, isFirstResponder: $emojiIsFocused)
                                .frame(width: 0, height: 0)

                            TextField("Enter your account name", text: $name)
                                .multilineTextAlignment(.center)
                        }
                        .padding(20)
                    }

                    Section("Account Balance") {
                        TextField("", value: $balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .multilineTextAlignment(.leading)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.primary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let accountsCreated = AccountModel(name: name, imageName: emojiText, balance: balance)
                        
                        context.insert(accountsCreated)
                        
                        do {
                            try context.save()
                            print("Accounts Created successfully \(accountsCreated)")
                           
                            
                        }  catch {
                            print("Error creatng account: \(error.localizedDescription)")
                        }
                        
                        dismiss()
                        
                    } label: {
                        Text("Save")
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
}

struct CreateAccounts_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateAccounts()
                .preferredColorScheme(.light)
            CreateAccounts()
                .preferredColorScheme(.dark)
        }
    }
}
