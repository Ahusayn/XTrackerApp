//
//  ReccuringView.swift
//  XTracker
//
//  Created by HSSN on 27/04/2025.
//

import SwiftUI

struct ReccuringView: View {
    
    let options = ["Never", "Daily", "Weekly", "Monthly",  "Yearly"]
    @State private var selectedOption: String = "Never"
    
    var body: some View {
        
        NavigationView {
            VStack {
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selectedOption = option
                        } label: {
                            VStack {
                                Text(option)
                                if option == selectedOption {
                                    Image(systemName: "checkmark")
                                    
                                }
                            }
                            
                            
                        }
                    }
                    
                } label: {
//                    HStack {
//                        Text(selectedOption)
//                            .foregroundStyle(Color.text)
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .foregroundStyle(Color.text)
//                    }
                  
                }
            }
        }
    }
}

#Preview {
    ReccuringView()
}
