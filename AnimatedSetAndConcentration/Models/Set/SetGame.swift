//
//  SetGame.swift
//  SetGame
//
//  Created by Nicholas Bonet on 9/30/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import Foundation

class SetGame {
    public var score = 0

    public var setDeck = [SetCard]()
    public var setCardsOnScreen = [SetCard]()
    public var setCardsSelected = [SetCard]()

    // Class initializer, simply build the deck for the game.
    public init() {
        resetGame()
    }

    // Resets the game instance.
    public func resetGame() {
        score = 0
        setDeck.removeAll()
        setCardsOnScreen.removeAll()
        setCardsSelected.removeAll()
        buildSetDeck()
    }

    // Handles card touched event.
    public func cardTouched(at index: Int) {
        let card = setCardsOnScreen[index]
        // If less than 3 cards are selected, either select or deselect the touched card.
        if setCardsSelected.count < 3 {
            if isCardSelected(card) {
                setCardsSelected.remove(at: setCardsSelected.firstIndex(of: card)!)
            } else { cardSelected(card) }
        }
        // If 3 cards are selected, check if set or not a set, and replace/clear cards
        // and select a card appropriately.
        else if setCardsSelected.count == 3 {
            if isSet() {
                if !setCardsSelected.contains(card) {
                    clearMatch()
                    cardSelected(card)
                } else {
                    clearMatch()
                }
            } else {
                clearMismatch()
                cardSelected(card)
            }
        }
    }

    // Handles adding three more cards to the game.
    // If there's a match, clear the matched cards and replace them.
    // If no match, add 3 cards to the game. (and clear mismatch is there is one)
    public func addThreeCards() {
        if isSet() {
            clearMatch()
        } else if setDeck.count > 0 {
            score.changeScore(value: -1)
            for _ in 1...3 { addCardToGame() }
            if setCardsSelected.count == 3 && !isSet() { clearMismatch() }
        }
    }

    // Test whether each attribute of the 3 cards are all equal or all unique
    // swiftlint:disable line_length
    public func isSet() -> Bool {
        if setCardsSelected.count == 3 {
            let cards = setCardsSelected
            if !((cards[0].color == cards[1].color) && (cards[1].color == cards[2].color) || (cards[0].color != cards[1].color) && (cards[1].color != cards[2].color) && (cards[0].color != cards[2].color)) {
                return false
            }
            if !((cards[0].shape == cards[1].shape) && (cards[1].shape == cards[2].shape) || (cards[0].shape != cards[1].shape) && (cards[1].shape != cards[2].shape) && (cards[0].shape != cards[2].shape)) {
                return false
            }
            if !((cards[0].shade == cards[1].shade) && (cards[1].shade == cards[2].shade) || (cards[0].shade != cards[1].shade) && (cards[1].shade != cards[2].shade) && (cards[0].shade != cards[2].shade)) {
                return false
            }
            if !((cards[0].count == cards[1].count) && (cards[1].count == cards[2].count) || (cards[0].count != cards[1].count) && (cards[1].count != cards[2].count) && (cards[0].count != cards[2].count)) {
                return false
            }
            return true
        } else { return false }
    }
    // swiftlint:enable line_length

    // Checks if card is in the selected cards array.
    public func isCardSelected(_ card: SetCard) -> Bool {
        return setCardsSelected.contains(card)
    }

    // Check whether the given card is part of a match
    public func isCardMatched(_ card: SetCard) -> MatchState {
        if setCardsSelected.count < 3 {
            return MatchState.unchecked
        } else if isCardSelected(card) && setCardsSelected.count == 3 {
            return isSet() ? MatchState.matched : MatchState.unmatched
        } else { return MatchState.unchecked }
    }

    // Adds card to selected card array.
    private func cardSelected(_ card: SetCard) {
        setCardsSelected.append(card)
    }

    // Called when a mismatch is detected, clears selected cards and applies score penalty.
    private func clearMismatch() {
        setCardsSelected.removeAll()
        score.changeScore(value: -2)
    }

    // Called when a match is detected. Clears selected cards, and replaces them if the deck isn't empty.
    private func clearMatch() {
        score.changeScore(value: 3)
        setCardsSelected.forEach {
            setCardsOnScreen.remove(at: setCardsOnScreen.firstIndex(of: $0)!)
            setCardsSelected.remove(at: setCardsSelected.firstIndex(of: $0)!)
            if setCardsOnScreen.count < 12 { addCardToGame() }
        }
    }

    // Safely handles adding a card to the game. If the deck is empty, do nothing.
    private func addCardToGame() {
        if setDeck.count > 0 { setCardsOnScreen.append(setDeck.removeFirst()) }
    }

    // Assembles the Set deck of all possible combinations of attributes, and adds the cards to the main deck.
    // Also shuffles the deck for us.
    private func buildSetDeck() {
        for color in SetCard.Coloring.all {
            for shade in SetCard.Shade.all {
                for shape in SetCard.Shape.all {
                    for index in 1...3 {
                        setDeck.append(SetCard(color: color, shade: shade, shape: shape, count: index))
                    }
                }
            }
        }
        setDeck.shuffle()
        // Since the cards are shuffled, take the first 12 from the deck
        // and assign them to setCardsOnScreen.
        for _ in 0...11 {
            addCardToGame()
        }
    }
}

extension Int {
    // Safely change the score without dipping into negative values.
    public mutating func changeScore(value: Int) {
        if value > 0 || self >= abs(value) { self += value } else if self <= abs(value) { self = 0 }
    }
}
