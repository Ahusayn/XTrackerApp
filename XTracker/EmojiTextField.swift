//
//  EmojiTextField.swift
//  XTracker
//
//  Created by HSSN on 18/05/2025.
//

import SwiftUI
import UIKit

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField

        init(_ parent: EmojiTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            if let lastEmoji = textField.text?.last {
                parent.text = String(lastEmoji)
                textField.text = String(lastEmoji) // Keep only the new emoji in UITextField
            }

        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFirstResponder = true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFirstResponder = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = EmojiOnlyTextField()
        textField.delegate = context.coordinator
        textField.font = UIFont.systemFont(ofSize: 1) // Hidden size
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .default
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if isFirstResponder && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFirstResponder && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
}

class EmojiOnlyTextField: UITextField {
    override var textInputContextIdentifier: String? {
        return "" // Required to show emoji keyboard on iOS 13+
    }

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return super.textInputMode
    }
}
