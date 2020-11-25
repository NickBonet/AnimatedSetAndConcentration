//
//  CardDeck.swift
//  Concentration
//
//  Created by Nicholas Bonet on 10/23/20.
//  Copyright © 2020 Nick Bonet. All rights reserved.
//

import Foundation

class CardDeck {
    private var numberOfSets = 20
    private var cards = [Card]()

    public init(numberOfCardsToMatch: Int) {
        var identifier = 0
        for _ in 1...numberOfSets {
            let card = Card(identifier)
            for _ in 1...numberOfCardsToMatch {
                cards.append(card)
            }
            identifier += 1
        }
    }

    public func dealCard() -> Card? {
        if count() > 0 {
            return cards.removeFirst()
        } else { return nil }
    }

    public func count() -> Int {
        return cards.count
    }

    public func isEmpty() -> Bool {
        return count() == 0 ? true : false
    }

    public func shuffle() {
        cards.shuffle()
    }
}
