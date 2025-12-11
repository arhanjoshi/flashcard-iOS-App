//
//  DeckView.swift
//

import SwiftUI

// Displays card's contents for preview
struct CardView: View {
    let card: Card
    var body: some View {
        VStack(alignment: .leading) {
            Text(card.question)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(card.theme.background)
        .cornerRadius(10)
    }
}

struct DeckView: View {
    @Binding var deck: Deck
    @State private var showingAddCardSheet: Bool = false
    @State private var newQuestion: String = ""
    @State private var newAnswer: String = ""
    @State private var newTheme: CardTheme = .blue
    
    var body: some View {
        VStack {
            // CODE HERE: Add button to navigate to StudyView if cards exist
            if deck.cards.isEmpty {
                Text("Cards do not exist.")
            }
            else {
                NavigationLink{
                    StudyView(cards: deck.cards)
                } label: {
                    HStack{
                        Image(systemName: "graduationcap.fill")
                        Text("Study Flashcards").fontWeight(.semibold)
                        
                        Image(systemName: "chevron.right").foregroundColor(.secondary)
                    }
                    .padding()
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            List {
                ForEach(deck.cards.indices, id: \.self) { index in
                    CardView(card: deck.cards[index])
                }
                // CODE HERE: Add delete cards functionality
                .onDelete{ offsets in deck.cards.remove(atOffsets: offsets)}
            }
            .listStyle(.plain)
        }
            .navigationTitle(deck.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddCardSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddCardSheet) {
                NavigationStack {
                    // CODE HERE: Using forms and sections ask user for information(question and answer)
                    //            and color theme. Use picker view and for each to select the color theme
                    Form{
                        Section("Question"){
                            TextField("Enter question", text: $newQuestion, axis: .vertical)
                        }
                        Section("Answer"){
                            TextField("Enter answer", text:$newAnswer, axis: .vertical)
                        }
                        Section("Theme"){
                            Picker("Card Theme", selection: $newTheme){
                                ForEach(CardTheme.allCases, id: \.self) { theme in
                                    HStack{
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(theme.background)
                                            .frame(width: 24, height: 16)
                                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(.gray.opacity(0.3)))
                                        Text(theme.rawValue.capitalized)
                                    }
                                    .tag(theme)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
