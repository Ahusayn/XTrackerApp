//
//    CustomDateFilterPicker.swift
//  XTracker
//
//  Created by HSSN on 28/05/2025.
//\

import SwiftUI
import SwiftData

struct CustomDateFilterPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var startDate: Date
    @Binding var endDate: Date

    @State private var isSelectingStartDate = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Select Date", selection: $isSelectingStartDate) {
                    Text("Start Date").tag(true)
                    Text("End Date").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
                
                DatePicker(
                    isSelectingStartDate ? "Start Date" : "End Date",
                    selection: isSelectingStartDate ? $startDate : $endDate,
                    in: isSelectingStartDate ? Date.distantPast...endDate : startDate...Date.distantFuture,
                    displayedComponents: [.date]
                )

                .datePickerStyle(.graphical)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filter by Date Range")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CustomDateFilterPicker(
        startDate: .constant(Date()),
        endDate: .constant(Calendar.current.date(byAdding: .day, value: 7, to: Date())!)
    )
}
