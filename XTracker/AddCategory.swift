import SwiftUI

struct AddCategory: View {
    @Environment(\.dismiss) var dismiss

    let colors: [Color] = [.purple, .blue, .red, .orange, .indigo, .green, .brown, .gray.opacity(0.3)]

    @State private var selectedColor: Color = .brown
    @State private var emojiText: String = "🥃"
    @State private var isEmojiPickerActive: Bool = false
    @State private var categoryName: String = ""
    @State private var selectedSide: SelectedSpendType = .expense
    @Environment(\.modelContext) var context

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                ZStack {
                    Button {
                        isEmojiPickerActive = true
                    } label: {
                        Text(emojiText)
                            .font(.system(size: 50))
                            .frame(width: 100, height: 100)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    }
                    
                    EmojiTextField(text: $emojiText, isFirstResponder: $isEmojiPickerActive)
                        .frame(width: 0, height: 0)
                }
                .padding(.bottom, 30)
                
                HStack(spacing: 16) {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(selectedColor == color ? 0.3 : 0), lineWidth: 2)
                            )
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }
                .padding(.bottom, 30)
                
                VStack(alignment: .leading, spacing: 16) {
                    Section {
                        TextField("Category Name", text: $categoryName)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color(.systemGroupedBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.gray.opacity(0.2))
                            )
                    } header: {
                        Text("Name")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Section {
                        Picker("Category Type", selection: $selectedSide) {
                            ForEach(SelectedSpendType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    } header: {
                        Text("Type")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedName.isEmpty else { return }

                        let newCategory = Category(
                            name: trimmedName,
                            imagename: emojiText,
                            detail: "Custom category created by user",
                            type: selectedSide,
                            tag: selectedColor
                        )

                        context.insert(newCategory)
                        print("New category added: \(newCategory.name)")
                        dismiss()
                    }
                }
            }
            .background(Color.background.ignoresSafeArea())
        }
    }
}

#Preview {
    AddCategory()
}
