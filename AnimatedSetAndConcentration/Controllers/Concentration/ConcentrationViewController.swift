//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by Nick Bonet on 8/31/20.
//  Copyright © 2020 Nick Bonet. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    @IBOutlet private weak var flipLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var twoCardButton: UIButton!
    @IBOutlet weak var threeCardButton: UIButton!
    private var emojiChoices = ["🚗", "🚕", "🚙", "🚒", "🚖", "🚘", "🚚", "🚛", "🚍", "🚌", "🚎", "🏎", "🚓", "🚐", "🚜", "🛺", "✈️", "🚤", "🚂", "🚆"]
    public var theme: [String] = [] {
        didSet {
            emojiChoices = theme
            startNewConcentrationGame()
        }
    }

    // Changes when one of the new game buttons is pressed, then sent to model.
    // Defaults to 2 card match game.
    private var cardsToMatch = 2

    public override func viewDidLoad() {
        super.viewDidLoad()
        twoCardButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        twoCardButton.layer.borderWidth = 1
        threeCardButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        threeCardButton.layer.borderWidth = 1
        updateViewFromModel()
    }

    // Instance of the actual game logic class.
    private lazy var game = Concentration(numberOfCardsToMatch: cardsToMatch)

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }

    @IBAction private func newGamePressed(_ sender: UIButton) {
        if sender.tag == 2 { cardsToMatch = 2 } else if sender.tag == 3 {
            cardsToMatch = 3
        }
        startNewConcentrationGame()
    }

    private func startNewConcentrationGame() {
        game.resetGame(numberOfCardsToMatch: cardsToMatch)
        if cardButtons != nil {
            for button in cardButtons {
                button.isHidden = false
            }
        }
        updateViewFromModel()
    }

    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                if game.cardsDealt.indices.contains(index) {
                    let card = game.cardsDealt[index]
                    if game.isCardSelected(card) {
                        button.setTitle(emoji(for: card), for: UIControl.State.normal)
                        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    } else {
                        button.setTitle("", for: UIControl.State.normal)
                        button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    }
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                    button.isHidden = true
                }
            }
            updateScoreLabel()
            updateFlipCountLabel()
        }
    }

    private func updateFlipCountLabel() {
        flipLabel.text = "Flips: \(game.flipCount)"
    }

    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }

    private func emoji(for card: Card) -> String {
        return emojiChoices[card.identifier]
    }
}
