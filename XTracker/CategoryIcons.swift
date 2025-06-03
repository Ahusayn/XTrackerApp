//
//  CategoryIcons.swift
//  XTracker
//
//  Created by HSSN on 24/04/2025.
//

import SwiftUI

struct CategoryIcons: View {
   
    var fixedType: SelectedSpendType? = nil
    
    // Default state for Add Transaction (shows picker)
    @State private var selectedType: SelectedSpendType = .expense
    
    var categories: [Category] = CategoryList.categories
    @Binding var selectedCategory: Category

    @Environment(\.dismiss) var dismiss

    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 30)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Picker is visible only when fixedType is nil
                    if fixedType == nil {
                        Picker("", selection: $selectedType) {
                            ForEach(SelectedSpendType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                        .padding()
                    }

                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(categories.filter {
                            $0.type == (fixedType ?? selectedType)
                        }, id: \.id) { category in
                            HStack {
                                Button {
                                    selectedCategory = category
                                    dismiss()
                                } label: {
                                    VStack(spacing: 12) {
                                        Image(category.imagename)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)

                                        Text(category.name)
                                            .foregroundStyle(Color.text)
                                            .font(.system(size: 15, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .lineLimit(1)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .frame(width: 70)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .background(Color.background.ignoresSafeArea())
        }
    }
}



struct CategoryIcons_Previews: PreviewProvider {
    @State static private var previewCategory = CategoryList.categories.first!
    
    static var previews: some View {
        Group {
            CategoryIcons(selectedCategory: $previewCategory)
                .preferredColorScheme(.light)
            
            CategoryIcons(selectedCategory: $previewCategory)
                .preferredColorScheme(.dark)
        }
    }
}
