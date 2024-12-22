//
//  CategoryDetails.swift
//  XTracker
//
//  Created by mac on 15/12/2024.
//

import SwiftUI

struct CategoryDetails: View {
    var categories: Category
    var body: some View {
        VStack {
            Image(categories.imagename)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .cornerRadius(12)
            
            Text(categories.name)
                .font(.title)
                .fontWeight(.semibold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.text)
             
            
        }
    }
}

#Preview {
    CategoryDetails(categories: CategoryList.categories.first!)
}
