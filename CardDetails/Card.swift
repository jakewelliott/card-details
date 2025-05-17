//
//  CreditCard.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/9/25.
//

import Foundation

enum CardType: String, CaseIterable, Codable {
    case debit = "Debit"
    case credit = "Credit"
    case prepaidDebit = "Prepaid Debit"
    case giftCard = "Gift Card"
}

struct Card: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var cardholderName: String
    var cardNumber: String
    var expiration: String
    var cvc: String
    var bankPhoneInternational: String
    var bankPhoneLocal: String
    var website: String?
    var cardType: CardType
    var balance: String?    // For Prepaid Debit and Gift Card
    var pin: String?        // For Debit
    var notes: String?
    
    init(
        id: UUID = UUID(),
        title: String = "",
        cardholderName: String = "",
        cardNumber: String = "",
        expiration: String = "",
        cvc: String = "",
        bankPhoneInternational: String = "",
        bankPhoneLocal: String = "",
        website: String? = nil,
        cardType: CardType = .credit,
        balance: String? = nil,
        pin: String? = nil,
        notes: String? = nil,
    ) {
        self.id = id
        self.title = title
        self.cardholderName = cardholderName
        self.cardNumber = cardNumber
        self.expiration = expiration
        self.cvc = cvc
        self.bankPhoneInternational = bankPhoneInternational
        self.bankPhoneLocal = bankPhoneLocal
        self.website = website
        self.cardType = cardType
        self.balance = balance
        self.pin = pin
        self.notes = notes
    }
}
