//
//  CategoriesPage.swift
//  XTracker
//
//  Created by hssn on 23/11/2024.
//

import SwiftUI

struct Accounts: View {
    var categories: [Category] = CategoryList.categories
    
    var body: some View {
        NavigationView {
            List(categories, id: \.id) { category in
                NavigationLink(destination: CategoryDetails(categories: category), label: {
                    HStack(spacing: 20) { // Wrap Image and VStack inside HStack
                        Image(category.imagename)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .cornerRadius(10)
                            .padding(.vertical, 4)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.name)
                                .font(.headline)
                                .foregroundColor(Color.text)
                                
                            Text(category.detail)
                                .font(.subheadline)
                                .foregroundColor(Color.text)
                        }
                    }
                })
               
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



#Preview {
    Accounts()
}
