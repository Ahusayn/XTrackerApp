import SwiftUI
import SwiftData

struct CustomKeypadBudget: View {
    @Binding var amount: String

    let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "*"]
    ]

    let buttonSize: CGFloat = 80
    let spacing: CGFloat = 40

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { key in
                        keypadButton(for: key)
                    }
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    func keypadButton(for key: String) -> some View {
        Button(action: {
            handleInput(key)
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: buttonSize, height: buttonSize)

                if key == "*" {
                    Image(systemName: "delete.left")
                        .foregroundColor(.red)
                        .font(.title2)
                } else {
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
            if !amount.isEmpty {
                amount.removeLast()
            }
        case ".":
            if !amount.contains(".") && amount.count < 12 {
                amount += "."
            }
        default:
            if digitCount < 12, input.allSatisfy({ $0.isNumber }) {
                amount = (amount == "0") ? input : amount + input
            }
        }
    }
}
