//
//  ProfilePage.swift
//  XTracker
//
//  Created by hssn on 23/11/2024.
//

import SwiftUI
import SwiftData

struct SettingsPage: View {
    
    @Environment(\.modelContext) private var context
    @State private var showDeletion = false

    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.background.ignoresSafeArea()
                VStack(spacing: 30) {
                    List {
                        Section {
                            HStack(spacing: 10) {
                                NavigationLink {
                                    CategoryModificaton()
                                } label: {
                            
                                    Label("Categories", systemImage: "chart.pie.fill")
                                }
                               
                                
                               
                            }
                            
                            HStack {
                                NavigationLink {
                                    Budgets()
                                } label: {
                                   
                                    Label("Budgets", systemImage: "wallet.pass.fill")
                                }
                               
                            }
                            
                            HStack {
                                NavigationLink {
                                    RecurringTransactions()
                                } label: {
                                    Label("Recurring Transactions", systemImage: "arrow.clockwise.circle.fill"    )
                                }
                            }
                            
                           
                            
                           
                            
                            
                        }
                        
                        
                        Section("DATA") {
                            HStack {
                                NavigationLink {
                                    ExportData()
                                } label: {
                                    Label("Export Data", systemImage: "square.and.arrow.up.fill")
                                }
                               
                            }
                            
                            HStack {
                                NavigationLink {
                                    EraseAllTransactions()
                                } label: {
                                    Label("Erase All Transactions", systemImage: "trash")
                                }
                               
                            }
                        }
                        
                        Section {
                            HStack {
                                NavigationLink {
                                   
                                } label: {
                                    Label("Currency", systemImage: "dollarsign.circle.fill")
                                }
                            }
                        }
                        
                        
                        Section  {
                            HStack {
                                NavigationLink {
                                     HelpFeedback()
                                } label: {
                                    Label("Help & Feedback", systemImage: "lightbulb.fill")
                                }
                            }
                            
                            HStack {
                                NavigationLink {
                                    FollowDeveloper()
                                } label: {
                                    Label("Follow Developer", systemImage: "person.fill")
                                }
                            }
                            
                            HStack {
                                NavigationLink {
                                    About()
                                } label: {
                                    Label("About", systemImage: "info.circle.fill")
                                }
                            }
                        }
                        
                    }
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                
            }
            
        }
    }

    
}



struct SettingsPage_Preview: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            SettingsPage()
                .preferredColorScheme(.light)
            
            SettingsPage()
                .preferredColorScheme(.dark)
        }
    }
}
