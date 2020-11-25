//
//  Concentration.swift
//  Concentration
//
//  Created by Nicholas Bonet on 9/3/20.
//  Copyright © 2020 Nick Bonet. All rights reserved.
//

import Foundation

class Concentration {
    private var cardsToMatch: Int
    private var cards: CardDeck = CardDeck(numberOfCardsToMatch: 2)
    private var cardsSelectedCount: Int {
        var count = 0
        for card in cardsDealt where card.isSelected { count += 1 }
        return count
    }
    public var cardsDealt = [Card]()
    public var flipCount = 0
    public var score = 0 {
        didSet {
            if score < 0 { score = 0 }
        }
    }

    public init(numberOfCardsToMatch: Int) {
        assert(numberOfCardsToMatch == 2 || numberOfCardsToMatch == 3, "Concentration.init(\(numberOfCardsToMatch)): Must have at least one pair of cards.")
        self.cardsToMatch = numberOfCardsToMatch
        resetGame(numberOfCardsToMatch: self.cardsToMatch)
    }

    public func chooseCard(at index: Int) {
        assert(cardsDealt.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not valid.")
        let card = cardsDealt[index]
        // If there's not enough cards for match, allow selection if not selected.
        if cardsSelectedCount < cardsToMatch {
            if !isCardSelected(card) {
                setCardSelected(index)
            }
        }
        // If there's enough cards for a match, check for the match.
        else if cardsSelectedCount == cardsToMatch {
            var selectedCards = [Card]()
            for card in cardsDealt {
                if card.isSelected { selectedCards.append(card) }
            }
            // Match found!
            if selectedCards.allSatisfy({$0 == selectedCards.first}) {
                score += cardsToMatch
                selectedCards.forEach {
                    // Replaces matched cards at their current index, so that the other cards are not scattered.
                    if let newCard = cards.dealCard() { cardsDealt[cardsDealt.firstIndex(of: $0)!] = newCard } else { cardsDealt.remove(at: cardsDealt.firstIndex(of: $0)!) }
                }
            }
            // No match found, deselect cards and penalize score if necessary.
            else {
                for card in selectedCards {
                    let index = cardsDealt.firstIndex(of: card)!
                    if card.wasSeen { score -= 1 }
                    cardsDealt[index].isSelected = false
                    cardsDealt[index].wasSeen = true
                }
            }
            setCardSelected(index)
        }
        print("Cards in deck: \(cards.count())")
        print("Cards dealt: \(cardsDealt.count)")
        print("Cards selected: \(cardsSelectedCount)")
    }

    // Reset all necessary variables for new game.
    public func resetGame(numberOfCardsToMatch: Int) {
        flipCount = 0
        score = 0
        self.cardsToMatch = numberOfCardsToMatch
        cardsDealt.removeAll()
        cards = CardDeck(numberOfCardsToMatch: self.cardsToMatch)
        cards.shuffle()
        while cardsDealt.count < 25 {
            cardsDealt.append(cards.dealCard()!)
        }
    }

    // Simply checks if the passed card is selected or not.
    public func isCardSelected(_ card: Card) -> Bool {
        return card.isSelected
    }

    // Sets properties for when a card is selected.
    private func setCardSelected(_ index: Int) {
        if cardsDealt.indices.contains(index) {
            cardsDealt[index].isSelected = true
            flipCount += 1
        }
    }
}
