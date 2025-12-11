//
//  StudyView.swift

import SwiftUI

struct StudyView: View {
    let cards: [Card]
    @State private var currentIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var isRandom: Bool = false
    @State private var shuffledCards: [Card] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // CODE HERE: Display current card’s question or answer, tappable to flip (ZStack, Text, tap gesture)
                let activeCards = isRandom ? shuffledCards : cards
                let hasCards = !activeCards.isEmpty
                
                if !hasCards{
                    Text("No cards to study.")
                        .foregroundColor(.secondary)
                        .padding(.top, 40)
                }
                else{
                    VStack(spacing: 6){
                        Text(isRandom ? "Mode: Random" : "Mode: Sequential")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Text("Card \(currentIndex + 1) of \(activeCards.count)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                // CODE HERE: Add buttons for previous and next cards (HStack, Button, disable)
                Button{
                    isFlipped.toggle()
                }
                label:{
                    let card = activeCards[currentIndex]
                    VStack(spacing: 12){
                        
                        Text(isFlipped ? card.answer : card.question)
                            .font(.title3).fontWeight(.semibold)
                            .multilineTextAlignment(.center).foregroundColor(.primary)
                            .padding(.horizontal)
                        
                        Text(isFlipped ? "Tap to see Question" : "Tap to see Answer")
                            .font(.caption).foregroundColor(.secondary)
                        
                    }
                    .padding(.vertical, 36)
                    .frame(maxWidth: .infinity).background(card.theme.background)
                    .cornerRadius(16).contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                
                
                HStack(spacing: 24){
                    Button{
                        
                        goPrev(activeCount: activeCards.count)
                    } label: {
                        Label("Previous", systemImage: "chevron.left")
                    }
                    .disabled(!hasCards)
                    
                    Button{
                        goNext(activeCount: activeCards.count)
                    } label: {
                        Label("Next", systemImage: "chevron.right")
                    }
                    .disabled(!hasCards)
                }
                .font(.headline)
                .padding(.top, 4)
                
                // CODE HERE: Add toggle button for random/sequential order
                Toggle(isOn: $isRandom){
                    Text("Random Order")
                }
                .padding(.horizontal).padding(.top, 8)
                .onChange(of: isRandom){ _, newValue in
                    if newValue{
                        shuffledCards = cards.shuffled()
                    }
                    else{
                        shuffledCards = cards
                    }
                    currentIndex = 0
                    isFlipped = false
                }
            }
            .navigationTitle("Study Flashcards")
            .onAppear{
                shuffledCards = cards
            }
        }
    }
        
        private func goNext(activeCount: Int){
            guard activeCount > 0 else{
                return
            }
            currentIndex = (currentIndex + 1) % activeCount
            isFlipped = false
        }
        
        private func goPrev(activeCount: Int){
            guard activeCount > 0 else {
                return
            }
            currentIndex = (currentIndex - 1 + activeCount) % activeCount
            isFlipped = false
        }
    }
