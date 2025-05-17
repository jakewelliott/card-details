//
//  CardDetailView.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/9/25.
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    var onEdit: (Card) -> Void
    var onDelete: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var auth = BiometricAuth()
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    @State private var pendingEdit = false
    
    func callNumber(_ number: String) {
        let tel = "tel://" + number.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        if let url = URL(string: tel) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            CardPreview(card: card, showSensitive: auth.isUnlocked)
                .padding(.top)
                .onTapGesture {
                    if !auth.isUnlocked {
                        auth.authenticate()
                    }
                }
            
            // CVC and other sensitive info (not shown on card)
            if auth.isUnlocked {
                VStack {
                    HStack {
                        if (card.pin) != nil {
                            HStack(spacing: 4) {
                                Text("PIN:")
                                    .font(.headline)
                                Text(card.pin!)
                                    .font(.headline)
                                    .textSelection(.enabled)
                            }.padding(.vertical, 4)
                            Spacer()
                        }
                        
                    }.padding(.horizontal)
                    HStack {
                        if (card.balance) != nil {
                            HStack(spacing: 4) {
                                Text("Balance:")
                                    .font(.headline)
                                Text(card.balance!)
                                    .font(.headline)
                                    .textSelection(.enabled)
                            }.padding(.vertical, 4)
                            Spacer()
                        }
                    }.padding(.horizontal)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if !card.bankPhoneInternational.isEmpty {
                    Button(action: {
                        callNumber(card.bankPhoneInternational)
                    }) {
                        HStack(spacing: 4) {
                            Text("Bank Intl:")
                            Text(card.bankPhoneInternational)
                                .foregroundColor(.blue)
                                .textSelection(.enabled)
                        }
                    }
                    .buttonStyle(.plain)
                }
                if !card.bankPhoneLocal.isEmpty {
                    Button(action: {
                        callNumber(card.bankPhoneLocal)
                    }) {
                        HStack(spacing: 4) {
                            Text("Bank Local:")
                            Text(card.bankPhoneLocal)
                                .foregroundColor(.blue)
                                .textSelection(.enabled)
                        }
                    }
                    .buttonStyle(.plain)
                }
                if let website = card.website, !website.isEmpty {
                    let displayURL = website
                    let url: URL? = {
                        if let url = URL(string: website), url.scheme != nil {
                            return url
                        } else if let url = URL(string: "https://\(website)") {
                            return url
                        }
                        return nil
                    }()
                    if let url = url {
                        Link(destination: url) {
                            HStack(spacing: 4) {
                                Text("Website:")
                                    .foregroundColor(.primary)
                                Text(displayURL)
                                    .foregroundColor(.blue)
                                    .textSelection(.enabled)
                            }
                        }
                    }
                }
                Text("")
                if let notes = card.notes, !notes.isEmpty {
                    Text("Notes:")
                    Text(notes)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Edit and Delete buttons
            HStack {
                Button("Edit") {
                    if auth.isUnlocked {
                        showingEdit = true
                    } else {
                        pendingEdit = true
                        auth.authenticate()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Delete") {
                    showingDeleteAlert = true
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .padding(.vertical)
        }
        .padding()
        .sheet(isPresented: $showingEdit) {
            CardEditView(card: card, onSave: { editedCard in
                onEdit(editedCard)
                showingEdit = false
                presentationMode.wrappedValue.dismiss()
            })
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Card"),
                message: Text("Are you sure you want to delete this card?"),
                primaryButton: .destructive(Text("Delete")) {
                    onDelete()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .onChange(of: auth.isUnlocked) {
            if auth.isUnlocked && pendingEdit {
                showingEdit = true
                pendingEdit = false
            }
        }
    }
}
