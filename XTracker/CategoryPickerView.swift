//
//  CategoryPickerView.swift
//  XTracker
//
//  Created by HSSN on 16/01/2025.
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedCategory: Category?
    
    let categories = CategoryList.categories
    
    var body: some View {
        NavigationView {
            List(categories, id: \.id) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    HStack {
                        Image(systemName: category.imagename)
                        Text(category.name)
                    }
                }
            }
            .navigationTitle("Select Category")
        }
    }
}
