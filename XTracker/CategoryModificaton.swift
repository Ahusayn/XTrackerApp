//
//  CategoryModificaton.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//


import SwiftUI
import SwiftData

struct CategoryModificaton: View {
    
    var categories: [Category] = CategoryList.categories
    @State private var selectedSide: SelectedSpendType = .expense
    @Query(sort: \TransactionModel.date) var transactions: [TransactionModel]
    @State private var isAddCtaegory = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    ForEach(categories.filter { $0.type == selectedSide} , id: \.id) { category in
                        HStack(spacing: 10) {
                            Image(category.imagename)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(category.tag.opacity(0.2))
                                )
                            
                            Text(category.name)
                                .foregroundStyle(Color.text)
                        }
                    }
                }
            }
            .sheet(isPresented: $isAddCtaegory) {
                AddCategory()
            }
            
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $selectedSide) {
                        ForEach(SelectedSpendType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                    .padding(.horizontal)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddCtaegory = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.accent)
                        
                        
                    }
                    
                }
            }
        }
        
            
        
    }
}

#Preview {
    CategoryModificaton()
}
