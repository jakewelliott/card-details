//
//  List.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/9/25.
//

import SwiftUI

struct CardListView: View {
    @State private var cards: [Card] = KeychainHelper.shared.loadCards()
    @State private var showingAddCard = false
    @State private var selectedCard: Card?

    // Save cards to Keychain whenever they change
    private func persistCards() {
        KeychainHelper.shared.saveCards(cards)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(cards) { card in
                    Button(action: { selectedCard = card }) {
                        VStack(alignment: .leading) {
                            Text(card.title.isEmpty ? "No Title" : card.title)
                                .font(.headline)
                            Text("•••• •••• •••• \(card.cardNumber.suffix(4))")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indices in
                    cards.remove(atOffsets: indices)
                    persistCards()
                }
            }
            .navigationTitle("My Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCard = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCard) {
                CardEditView(card: Card(), onSave: { newCard in
                    cards.append(newCard)
                    persistCards()
                    showingAddCard = false
                })
            }
            .sheet(item: $selectedCard) { card in
                CardDetailView(
                    card: card,
                    onEdit: { editedCard in
                        if let idx = cards.firstIndex(of: card) {
                            cards[idx] = editedCard
                            persistCards()
                        }
                        selectedCard = nil
                    },
                    onDelete: {
                        cards.removeAll { $0.id == card.id }
                        persistCards()
                        selectedCard = nil
                    }
                )
            }
        }
    }
}

