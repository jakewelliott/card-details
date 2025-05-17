//
//  CardEditView.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/9/25.
//

import SwiftUI

struct CardEditView: View {
    @State var card: Card
    var onSave: (Card) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func formatExpirationInput(_ value: String) {
        // Remove all non-digit characters
        let digits = value.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        var result = ""
        
        // Add the first two digits (month)
        for (index, char) in digits.prefix(4).enumerated() {
            if index == 2 {
                result += "/"
            }
            result.append(char)
        }
        // Prevent infinite loop by only updating if changed
        if result != card.expiration {
            card.expiration = result
        }
    }
    
    func formatCardNumberInput(_ value: String) {
        // Remove all non-digit characters
        let digits = value.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        // Limit to 16 digits
        let limitedDigits = String(digits.prefix(16))
        // Group into chunks of 4
        let grouped = stride(from: 0, to: limitedDigits.count, by: 4).map { i -> String in
            let start = limitedDigits.index(limitedDigits.startIndex, offsetBy: i)
            let end = limitedDigits.index(start, offsetBy: min(4, limitedDigits.count - i), limitedBy: limitedDigits.endIndex) ?? limitedDigits.endIndex
            return String(limitedDigits[start..<end])
        }
        let result = grouped.joined(separator: " ")
        // Prevent infinite loop
        if result != card.cardNumber {
            card.cardNumber = result
        }
    }
    
    func formatPhoneNumberInput(_ value: String, maxDigits: Int = 10) -> String {
        // Remove all non-digit characters
        let digits = value.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        let limited = String(digits.prefix(maxDigits))
        
        var formatted = ""
        let count = limited.count
        
        if count == 0 {
            formatted = ""
        } else if count < 4 {
            formatted = limited
        } else if count < 7 {
            let area = limited.prefix(3)
            let prefix = limited.suffix(count - 3)
            formatted = "(\(area)) \(prefix)"
        } else {
            let area = limited.prefix(3)
            let prefix = limited.dropFirst(3).prefix(3)
            let line = limited.dropFirst(6)
            formatted = "(\(area)) \(prefix)-\(line)"
        }
        
        return formatted
    }
    
    func formatInternationalPhoneNumber(_ value: String, maxDigits: Int = 15) -> String {
        let digits = value.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        let limited = String(digits.prefix(maxDigits))
        // Group into blocks of 3 or 4
        let grouped = stride(from: 0, to: limited.count, by: 3).map { i -> String in
            let start = limited.index(limited.startIndex, offsetBy: i)
            let end = limited.index(start, offsetBy: min(3, limited.count - i), limitedBy: limited.endIndex) ?? limited.endIndex
            return String(limited[start..<end])
        }
        return grouped.joined(separator: " ")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Info")) {
                    TextField("Title", text: $card.title).textInputAutocapitalization(.words)
                    Picker("Card Type", selection: $card.cardType) {
                        ForEach(CardType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    TextField("Cardholder Name", text: $card.cardholderName).textInputAutocapitalization(.words).textContentType(.name)
                    TextField("Number", text: $card.cardNumber).textContentType(.creditCardNumber).keyboardType(.numberPad).onChange(of: card.cardNumber) {
                        formatCardNumberInput(card.cardNumber)
                    }
                    TextField("Expiration", text: $card.expiration)
                        .textContentType(.creditCardExpiration)
                        .keyboardType(.numberPad)
                        .onChange(of: card.expiration) {
                            formatExpirationInput(card.expiration)
                        }
                    TextField("CVC", text: $card.cvc).textContentType(.creditCardSecurityCode).keyboardType(.numberPad)
                    if card.cardType == .prepaidDebit || card.cardType == .giftCard {
                        TextField("Balance", text: Binding($card.balance, default: "")).keyboardType(.decimalPad)
                    }
                    if card.cardType != .credit {
                        SecureField("PIN", text: Binding($card.pin, default: "")).keyboardType(.numberPad)
                    }
                }
                Section(header: Text("Bank")) {
                    TextField("Local Phone", text: $card.bankPhoneLocal)
                        .keyboardType(.phonePad)
                        .onChange(of: card.bankPhoneLocal) {
                            card.bankPhoneLocal = formatPhoneNumberInput(card.bankPhoneLocal)
                        }
                    TextField("International Phone", text: $card.bankPhoneInternational)
                        .keyboardType(.phonePad)
                        .onChange(of: card.bankPhoneInternational) {
                            card.bankPhoneInternational = formatInternationalPhoneNumber(card.bankPhoneInternational)
                        }
                    TextField("Website", text: Binding($card.website, default:""))
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                }
                Section(header: Text("Notes")) {
                    TextEditor(text: Binding($card.notes, default: ""))
                        .frame(minHeight: 80)
                        .autocorrectionDisabled(false)
                        .textInputAutocapitalization(.sentences)
                }
            }
            .navigationTitle("Edit Card")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(card)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

extension Binding {
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}

