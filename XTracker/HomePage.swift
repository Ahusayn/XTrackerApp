//
//  HomePage.swift
//  XTracker
//
//  Created by hssn on 12/11/2024.
//


import SwiftUI
import SwiftData
import Charts

struct HomePage: View {
    
    
    @Environment(\.modelContext) var context
    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]

    
    @Query(sort: \ProfileModel.firstName) var profile: [ProfileModel]
    
    @State private var isAddEpenseSelecttionView = false
    @State private var isAddTransactionManually = false
    
    @State private var selectedSide: SelectedSpendType = .expense
    
    var filteredTransactions: [TransactionModel] {
        transactions.filter { $0.type == selectedSide }
    }
    
    

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    Picker("", selection: $selectedSide) {
                        ForEach(SelectedSpendType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                    .padding()
                    
                    if !transactions.isEmpty {
                        //MARK: - Charts
                        TransactionsChartView(selectedType: selectedSide)
                        //MARK: - RecentTransaction List
                        RecentTransactionList(selectedType: selectedSide)
                    }
                    else {
                        Spacer(minLength: 200)
                        
                        VStack(spacing: 25) {
                            Image(systemName: "banknote")
                                .font(.system(size: 30))
                            Text("You have no transactions this month!")
                                .font(.headline)
                                .foregroundColor(Color.primary)
                            Text("Add Transactions by tapping the + button below")
                                .font(.subheadline)
                                .foregroundColor(Color.primary)
                        }
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                   

                }
            }
            
            
            
            .sheet(isPresented: $isAddTransactionManually){
                AddTransactionsManually()
                
            }
            
            
        
            .padding(.horizontal)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    if let userProfile = profile.first {
//                               Text("✌🏿 Hey \(userProfile.firstName)!")
//                                   .font(.title2)
//                           } else {
//                               Text("✌🏿 Hey!")
//                                   .font(.title2)
//                           }
//
//                }

                ToolbarItem(placement: .navigationBarTrailing) {
                       Button  {
                           isAddTransactionManually = true
                       } label: {
                           Image(systemName: "plus")
                               .symbolRenderingMode(.palette)
                               .foregroundStyle(Color.text)
                       }
                    }
                    
                    // Bell badge icon
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Filter Tapped")
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.text)
                    }
                  
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .accentColor(.primary)
        .onAppear {
            print("Number of transactions: \(transactions.count)")
            transactions.forEach { print($0) }
        }
    }
}







struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomePage()
                .preferredColorScheme(.light)

            HomePage()
                .preferredColorScheme(.dark)
        }
    }
}
