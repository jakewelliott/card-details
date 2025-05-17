//
//  ContentView.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var card = Card()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                CreditCardPreview(card: card)
                Form {
                    Section(header: Text("Card Details")) {
                        TextField("Cardholder Name", text: $card.cardholderName)
                        TextField("Card Number", text: $card.cardNumber)
                        TextField("Expiration (MM/YY)", text: $card.expiration)
                        SecureField("CVC", text: $card.cvc)
                    }
                    Section(header: Text("Bank Contact")) {
                        TextField("Bank Phone (Intl.)", text: $card.bankPhoneInternational)
                        TextField("Bank Phone (Local)", text: $card.bankPhoneLocal)
                    }
                    // For user-defined fields, consider a dynamic list or another section.
                }
                .navigationTitle("Add Credit Card")
            }
            .padding()
        }
    }
}

struct CreditCardPreview: View {
    let card: Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                )
                .frame(height: 200)
            VStack(alignment: .leading, spacing: 16) {
                Text(card.cardNumber.isEmpty ? "•••• •••• •••• ••••" : card.cardNumber)
                    .font(.title2)
                    .foregroundColor(.white)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Cardholder")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.cardholderName.isEmpty ? "NAME" : card.cardholderName)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Expires")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.expiration.isEmpty ? "MM/YY" : card.expiration)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
