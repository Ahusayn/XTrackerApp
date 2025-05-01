//
//  AddTransactionsManually.swift
//  XTracker
//
//  Created by HSSN on 27/03/2025.
//


import SwiftUI

struct AddTransactionsManually: View {
    
    @Environment(\.modelContext)  private var context
    @Environment(\.dismiss) var dismiss

   
    
    @State private var isSelectAccount = false
    @State private var isSelectCategory = false
    @State private var transactiontype: Bool = true
    @State var amount: String = "0"
    @State var comment: String = ""
    @State var selectedDate = Date()
    @State var showDatePicker = false
    @State var showRecurring = false
    
    @State private var rawAmount: String = ""
    @FocusState private var isAmountFocused: Bool
    var categories: [Category] =  CategoryList.categories
    @State private var selectedCategory: Category = CategoryList.categories.first!
    var accounts: [AccountModel] = AccountList.paymentType
    @State private var selectedAccounts: AccountModel = AccountList.paymentType.first!
    
    
    
    
    
    
    var formattedAmount: String {
        let currencySymbol = Locale.current.currencySymbol ?? "$"
        
        if amount.isEmpty {
            return "\(currencySymbol)0"
        }
        
        return "\(currencySymbol)\(amount)"
    }
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                //MARK: - Account Type & Category
                HStack(spacing: 10) {
                    Button {
                        isSelectAccount = true
                    } label: {
                        Image(selectedAccounts.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(selectedAccounts.name)
                            .bold()
                            .foregroundStyle(Color.text)
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .foregroundStyle(Color.text)
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button {
                        isSelectCategory = true
                    } label: {
                        Image(selectedCategory.imagename)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height:30)
                        Text(selectedCategory.name)
                            .bold()
                            .foregroundStyle(Color.text)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: 80)
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .foregroundStyle(Color.text)
                    .background(Color.brown.opacity(0.5))
                    .cornerRadius(8)
                }
                .layoutPriority(1)
                .padding()
                
                //                //MARK: - Transaction Type Toggle
                //                HStack(alignment: .center) {
                //                    TransactionTypeToggle(isIncome: $transactiontype)
                //                }
                //                .padding(.bottom, 10)
                
                //MARK: - Amount & Description
                VStack(alignment: .center) {
                    Text("\(formattedAmount)")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxHeight: 60)
                    
                    
                    TextField("Add Transaction Merchant..", text: $comment)
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                CustomKeypadView(
                    amount: $amount,
                    showDatePicker: $showDatePicker,
                    selectedDate: $selectedDate,
                    comment: $comment,
                    selectedCategory: selectedCategory,
                    selectedAccounts: selectedAccounts,
                    onSave: { dismiss() } // ✅ fixed
                )



            }
            .background(Color.background)
            .ignoresSafeArea(.keyboard)
            
            
            
            .sheet(isPresented: $isSelectAccount) {
                AccountIcons(selectedAccounts: $selectedAccounts)
                    .presentationDetents([.fraction(0.5), .large])
                    .presentationDragIndicator(.hidden)
            }
            
            .sheet(isPresented: $isSelectCategory) {
                CategoryIcons(selectedCategory: $selectedCategory)
                    .presentationDetents([.fraction(0.5), .large])
                    .presentationDragIndicator(.hidden)
            }
            
            
        }
    }
    
    
    
   
}


// MARK: - Custom Keypad
struct CustomKeypadView: View {
    @Binding var amount: String
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: Date
    @Binding var comment: String
    
    @Environment(\.modelContext) private var context

    var selectedCategory: Category
    var selectedAccounts: AccountModel
    var onSave: () -> Void // <-- Add this
    
    let options = ["Monthly", "Weekly", "Daily", "Never"]
    @State private var selectedOption: String = "Never"
    

    

    let keypads: [[String]] = [
        ["1", "2", "3", "*"],
        ["4", "5", "6", "date"],
        ["7", "8", "9", ""],
        ["repeat", "0", ".", ""]
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 12) {
                ForEach(0..<keypads.count, id: \.self) { rowIndex in
                    HStack(spacing: 12) {
                        ForEach(0..<keypads[rowIndex].count, id: \.self) { colIndex in
                            let key = keypads[rowIndex][colIndex]

                            if (rowIndex == 2 || rowIndex == 3) && colIndex == 3 {
                                Spacer()
                                    .frame(width: 80, height: 80)
                            } else {
                                keypadButton(for: key)
                            }
                        }
                    }
                }
            }
            
            

            Button(action: {
                handleInput("add")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.black)
                        .frame(width: 80, height: (80 * 2 + 12))

                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            .padding(.trailing, 2)
            .padding(.bottom, 2)
        }
        
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(selectedDate: $selectedDate)
                .presentationDetents([.fraction(0.5)])
        }
        
        
       
        
    }

    @ViewBuilder
    func keypadButton(for key: String) -> some View {
        Button(action: {
            handleInput(key)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)

                if key == "*" {
                    Image(systemName: "delete.left")
                        .foregroundColor(.red)
                } else if key == "date" {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                } else if key == "repeat" {
                    Menu {
                        ForEach(options, id: \.self) { option in
                            Button {
                                selectedOption = option
                            } label: {
                                HStack {
                                    Text(option)
                                    Spacer()
                                    if option == selectedOption {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 80, height: 80)   // Same size
                            Image(systemName: "repeat")
                                .foregroundColor(.green)
                                .font(.title2) // Make it same size as other icons
                        }
                    }
                    .frame(width: 80, height: 80) // <-- Important! Force the Menu itself to have same frame
                }

                 else {
                    Text(key)
                        .font(.title)
                        .foregroundColor(.black)
                }
            }
        }
    }

    func handleInput(_ input: String) {
        let digitCount = amount.filter { $0.isNumber }.count
        
        switch input {
        case "*":
            if !amount.isEmpty { amount.removeLast() }
        case ".":
            if !amount.contains(".") && amount.count < 12 {
                amount += "."
            }
        case "add":
            let newTransaction = TransactionModel(
                comment: comment,
                date: selectedDate,
                amount: Double(amount) ?? 0.0,
                selectedCategory: selectedCategory,
                paymentType: selectedAccounts.name == "Cash" ? "Cash" : "Account",
                account: selectedAccounts.name == "Cash" ? nil : selectedAccounts
            )

            context.insert(newTransaction)
            do {
                try context.save()
                print("Transaction saved : \(amount), \(selectedCategory.name)")
            } catch {
                print("Error saving transaction: \(error.localizedDescription)")
            }

            
            // ✅ Dismiss the sheet
            onSave()

            
           
        case "date":
            showDatePicker = true
        case "repeat":
            print("Repeat Tapped")
        default:
            // check digits count except .
            if digitCount < 12 , input.allSatisfy( {$0.isNumber}) {
                if amount == "0" {
                    amount = input
                } else {
                    amount += input
                }
            }
        }
    }
}

// MARK: - TransactionTypeToggle
struct TransactionTypeToggle: View {
    @Binding var isIncome: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                isIncome = false
            }) {
                Text("-")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 50, height: 40)
                    .foregroundColor(isIncome ? .gray : .white)
                    .background(isIncome ?   Color.gray.opacity(0.3) : Color.red )
            }

            Button(action: {
                isIncome = true
            }) {
                Text("+")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 50, height: 40)
                    .foregroundColor(isIncome ? .white : .gray)
                    .background(isIncome ? Color.green : Color.gray.opacity(0.3))
                    .cornerRadius(12, corners: [.topRight, .bottomRight])

            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct AddTransactionsManually_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            AddTransactionsManually()
                .preferredColorScheme(.light)

            AddTransactionsManually()
                .preferredColorScheme(.dark)
        }
    }
}

