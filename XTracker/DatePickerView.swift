//
//  DatePickerView.swift
//  XTracker
//
//  Created by HSSN on 27/04/2025.
//

import SwiftUI

struct DatePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding  var selectedDate: Date
    
    var body: some View {
        NavigationView {
            VStack {
           
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { selectedDate },
                            set: { newDate in
                                selectedDate = newDate
                                dismiss() // 👈 dismiss immediately when picked
                            }
                        ),
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .tint(Color.text)
                    .padding()
                    
                
            }
        }
    }
}

#Preview {
    DatePickerView(selectedDate: .constant(Date()))
}
