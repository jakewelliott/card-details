//
//  KeychainHelper.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/16/25.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}

    private let service = "com.yourcompany.CardDetails"
    private let account = "cards"

    func saveCards(_ cards: [Card]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(cards) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary) // Remove old item

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemAdd(attributes as CFDictionary, nil)
    }

    func loadCards() -> [Card] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            let decoder = JSONDecoder()
            if let cards = try? decoder.decode([Card].self, from: data) {
                return cards
            }
        }
        return []
    }
}
