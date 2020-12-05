//
//  SetCardView.swift
//  SetGame
//
//  Created by Nicholas Bonet on 10/14/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import UIKit

@IBDesignable class SetCardView: UIView {
    // Defaults for the view when created. They're overriden once the view is initialized fully.
    @IBInspectable private var borderColor: UIColor = UIColor.white
    @IBInspectable private var shapeColor: UIColor = UIColor.red
    private var cardCornerRadius: CGFloat = 5
    private var isFaceUp = false {
        didSet {
            setNeedsDisplay()
        }
    }
    private var card: SetCard? {
        didSet {
            setNeedsDisplay()
        }
    }

    // Required initializers for subclassing UIView.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // Initializer for setting card view properties from a SetCard.
    public convenience init(frame: CGRect, card: SetCard, selected: Bool, matchState: MatchState) {
        self.init(frame: frame)
        updateCardView(newCard: card, selected: selected, matchState: matchState)
    }

    public func isCardFaceUp() -> Bool {
        return isFaceUp
    }

    // Method to handle updating card view properties on init or redraw.
    public func updateCardView(newCard: SetCard, selected: Bool, matchState: MatchState) {
        self.shapeColor = setShapeColor(newCard.color)
        self.borderColor = setBorderColor(selected, matchState)
        self.card = newCard
    }

    // Returns proper shape color depending on SetCard value.
    private func setShapeColor(_ coloring: SetCard.Coloring) -> UIColor {
        switch coloring {
        case SetCard.Coloring.red:
            return UIColor.red
        case SetCard.Coloring.green:
            return UIColor.green
        case SetCard.Coloring.purple:
            return UIColor.purple
        }
    }

    // Sets the shading of the shapes.
    private func setShading(_ path: UIBezierPath) -> UIBezierPath {
        let shadePath = UIBezierPath()
        shadePath.append(path)

        switch card!.shade {
        case SetCard.Shade.filled:
            shapeColor.setFill()
        case SetCard.Shade.empty:
            UIColor.white.setFill()
        case SetCard.Shade.striped:
            UIColor.white.setFill()
            shadePath.addClip()
            // Borrowed this from the class demo, with slight modification to dy.
            var start = CGPoint(x: 0.0, y: 0.0)
            var end = CGPoint(x: bounds.size.width, y: 0.0)
            let deltaY: CGFloat = bounds.size.height * 0.1
            while start.y <= bounds.size.height {
                shadePath.move(to: start)
                shadePath.addLine(to: end)
                start.y += deltaY
                end.y += deltaY
            }
        }
        return shadePath
    }

    // Returns the proper color of border based on whether the current card view
    // is selected/part of a match or mismatch.
    private func setBorderColor(_ selected: Bool, _ matched: MatchState) -> UIColor {
        if selected && matched == MatchState.matched {
            return UIColor.green
        } else if selected && matched == MatchState.unmatched {
            return UIColor.red
        } else if selected && matched == MatchState.unchecked {
            return UIColor.blue
        } else { return UIColor.white }
    }

    // Takes care of showing the shapes on the view, including coloring and shading.
    private func drawPath(_ path: UIBezierPath) {
        shapeColor.setStroke()
        let finalPath = setShading(path)
        finalPath.lineWidth = 2.0
        finalPath.fill()
        finalPath.stroke()
    }

    // Takes care of the flip animation for the card view.
    public func flipCard(closure: @escaping () -> Void) {
        UIView.transition(with: self, duration: 0.6, options: [.transitionFlipFromLeft], animations: {
            self.isFaceUp = !self.isFaceUp
        }, completion: { _ in
            closure()
        })
    }

    private func drawBackOfCard() {
        self.layer.cornerRadius = cardCornerRadius
        self.clipsToBounds = true

        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardCornerRadius)
        roundRect.addClip()
        roundRect.lineWidth = 4.5
        UIColor.gray.setFill()
        UIColor.gray.setStroke()
        roundRect.fill()
        roundRect.stroke()
    }

    private func drawFrontOfCard() {
        self.layer.cornerRadius = cardCornerRadius
        self.clipsToBounds = true

        let roundRect = UIBezierPath(roundedRect: bounds, cornerRadius: cardCornerRadius)
        roundRect.addClip()
        roundRect.lineWidth = 4.5
        UIColor.white.setFill()
        borderColor.setStroke()
        roundRect.fill()
        roundRect.stroke()

        let path = UIBezierPath()
        switch card!.shape {
        case SetCard.Shape.diamond:
            path.drawDiamond(bounds, card!.count)
        case SetCard.Shape.oval:
            path.drawOval(bounds, card!.count)
        case SetCard.Shape.squiggle:
            path.drawSquiggle(bounds, card!.count)
        }

        drawPath(path)
    }

    // Main draw method of the custom view.
    public override func draw(_ rect: CGRect) {
        if !isFaceUp {
            drawBackOfCard()
        } else {
            drawFrontOfCard()
        }
    }
}
