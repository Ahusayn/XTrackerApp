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
    @Query(sort: \AccountModel.name) var savedAccounts: [AccountModel]
    
    @State private var selectedFilterType: FilterType = .all
    @State private var customFilterDate: Date? = nil

    @State private var showFilterSheet = false
    
    func ensureCashAccountExists() {
        if !savedAccounts.contains(where: { $0.name == "Cash" }) {
            let cash = AccountModel(name: "Cash", imageName: "💵")
            context.insert(cash)
            try? context.save()
        }
    }
    
    @Query(sort: \ProfileModel.firstName) var profile: [ProfileModel]
    
    @State private var isAddEpenseSelecttionView = false
    @State private var isAddTransactionManually = false
    @State private var isSearchTransactions = false
    
    @State private var selectedSide: SelectedSpendType = .expense
    
    var filteredTransactions: [TransactionModel] {
        let base = transactions.filter { $0.type == selectedSide }
        let calendar = Calendar.current

        switch selectedFilterType {
        case .all:
            return base
        case .daily:
            return base.filter { calendar.isDateInToday($0.date) }
        case .weekly:
            return base.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) }
        case .monthly:
            return base.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .month) }
        case .yearly:
            return base.filter { calendar.isDate($0.date, equalTo: Date(), toGranularity: .year) }
        case .custom(let startDate, let endDate):
            return base.filter { transaction in
                transaction.date >= startDate && transaction.date <= endDate
            }
        }
    }

    var body: some View {
        NavigationStack {
            
//            VStack(spacing: 0) {
//                Picker("", selection: $selectedSide) {
//                    ForEach(SelectedSpendType.allCases, id: \.self) {
//                        Text($0.rawValue)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .frame(width: 200)
//                .padding()
//            }
           
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    
                    if !filteredTransactions.isEmpty {
//                        //MARK: - Charts
//                        TransactionsChartView(selectedType: selectedSide, selectedFilter: .all)
//                        //MARK: - RecentTransaction List
//                        RecentTransactionList(selectedType: selectedSide, selectedFilter: .all)
                        TransactionsDashboard(
                            selectedFilter: $selectedFilterType,
                            selectedType: $selectedSide
                        )

                    }
                    else {
                        Spacer(minLength: 200)
                        
                        VStack(spacing: 25) {
                            Image(systemName: "banknote")
                                .font(.system(size: 30))
                            Text("You have no transactions ")
                                .font(.headline)
                                .foregroundColor(Color.primary)
                            Text("Add Transactions by tapping the + button above")
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
                               .foregroundStyle(Color.accent)
                       }
                    }
                    
                // Filter button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.accent)
                    }
                }
               
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isSearchTransactions = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.accent)
                    }
                    .sheet(isPresented: $isSearchTransactions) {
                        SearchTransactions()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $selectedSide) {
                        ForEach(SelectedSpendType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterTransactions(selectedFilter: $selectedFilterType)
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .accentColor(.primary)
        .onAppear {
            print("Number of transactions: \(transactions.count)")
            transactions.forEach { print($0) }
            ensureCashAccountExists()
            
            if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                print("Database path: \(url.path)")
            }

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
