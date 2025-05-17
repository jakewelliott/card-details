//
//  CardPreview.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/16/25.
//

import SwiftUI

struct CardPreview: View {
    let card: Card
    let showSensitive: Bool

    var body: some View {
        ZStack {
            // Card background with gradient and subtle overlay
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.purple.opacity(0.85)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(radius: 8)
                .frame(height: 220)

            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    // Chip image
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.white.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 40, height: 28)
                        .shadow(radius: 1)
                    Spacer()
                    // Card type
                    Text(card.cardType.rawValue)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(8)
                }

                Spacer()

                if showSensitive {
                    // Card Number
                    Text(card.cardNumber.isEmpty
                         ? "No Card Number Saved"
                         : card.cardNumber)
                        .font(.system(size: 22, weight: .semibold, design: .monospaced)) // Shrunk font
                        .foregroundColor(.white)
                        .tracking(4)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .accessibilityLabel("Card Number")
                        .textSelection(.enabled)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cardholder")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                            Text(card.cardholderName.isEmpty ? "NAME" : card.cardholderName)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Expires")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                            Text(card.expiration.isEmpty
                                 ? "MM/YY"
                                 : card.expiration)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                                .textSelection(.enabled)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CVC")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                            Text(card.cvc.isEmpty
                                 ? "•••"
                                 : card.cvc)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                                .textSelection(.enabled)
                        }
                    }
                } else {
                    // Card Number
                    Text(card.cardNumber.isEmpty
                         ? "•••• •••• •••• ••••"
                         : (showSensitive ? card.cardNumber : "•••• •••• •••• \(card.cardNumber.suffix(4))"))
                        .font(.system(size: 22, weight: .semibold, design: .monospaced)) // Shrunk font
                        .foregroundColor(.white)
                        .tracking(4)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .accessibilityLabel("Card Number")

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cardholder")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                            Text(card.cardholderName.isEmpty ? "NAME" : card.cardholderName)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Expires")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                            Text(card.expiration.isEmpty
                                 ? "MM/YY"
                                 : (showSensitive ? card.expiration : "••/••"))
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("CVC")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                            Text(card.cvc.isEmpty
                                 ? "•••"
                                 : (showSensitive ? card.cvc : "•••"))
                                .font(.callout)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .frame(height: 220)
        .padding(.horizontal)
    }
}
