//
//  UIBezierPathExtensions.swift
//  SetGame
//
//  Created by Nicholas Bonet on 10/18/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import UIKit

extension UIBezierPath {
    // Methods to draw all of the necessary shapes. They scale with card size perfectly.
    public func drawDiamond(_ bounds: CGRect, _ count: Int) {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: bounds.midX, y: bounds.size.height * 0.05))
        diamond.addLine(to: CGPoint(x: bounds.size.width * 0.4, y: bounds.midY))
        diamond.addLine(to: CGPoint(x: bounds.midX, y: bounds.size.height * 0.95))
        diamond.addLine(to: CGPoint(x: bounds.size.width * 0.6, y: bounds.midY))
        diamond.close()
        self.appendShapes(diamond, count, bounds)
    }

    public func drawOval(_ bounds: CGRect, _ count: Int) {
        let rect = CGRect(x: bounds.midX * 0.80, y: bounds.size.height * 0.05,
                          width: bounds.size.width * 0.20, height: bounds.maxY * 0.9)
        let oval = UIBezierPath(roundedRect: rect, cornerRadius: 25)
        self.appendShapes(oval, count, bounds)
    }

    public func drawSquiggle(_ bounds: CGRect, _ count: Int) {
        let squiggle = UIBezierPath()
        let topEndpoint = CGPoint(x: bounds.midX, y: bounds.size.height * 0.05)
        let botEndpoint = CGPoint(x: bounds.midX * 0.7, y: bounds.size.height * 0.95)
        squiggle.move(to: topEndpoint)
        squiggle.addCurve(to: botEndpoint,
                          controlPoint1: CGPoint(x: bounds.midX * 0.15, y: bounds.size.height * 0.25),
                          controlPoint2: CGPoint(x: bounds.midX * 1.05, y: bounds.size.height * 0.45))
        squiggle.addCurve(to: topEndpoint,
                          controlPoint1: CGPoint(x: bounds.midX * 1.45, y: bounds.size.height * 0.8),
                          controlPoint2: CGPoint(x: bounds.midX * 0.55, y: bounds.size.height * 0.25))
        squiggle.apply(CGAffineTransform(translationX: bounds.size.width * 0.09, y: 0))
        self.appendShapes(squiggle, count, bounds)
    }

    // Takes care of duplicating shapes if needed. Scales when card is resized too!
    private func appendShapes(_ path: UIBezierPath, _ count: Int, _ bounds: CGRect) {
        switch count {
        case 1:
            self.append(path)
        case 2:
            let path2 = path.copy() as? UIBezierPath
            path.apply(CGAffineTransform(translationX: (bounds.midX * 0.3), y: 0))
            path2!.apply(CGAffineTransform(translationX: -(bounds.midX * 0.3), y: 0))
            self.append(path)
            self.append(path2!)
        case 3:
            let path2 = path.copy() as? UIBezierPath
            let path3 = path.copy() as? UIBezierPath
            path2!.apply(CGAffineTransform(translationX: (bounds.midX * 0.55), y: 0))
            path3!.apply(CGAffineTransform(translationX: -(bounds.midX * 0.55), y: 0))
            self.append(path)
            self.append(path2!)
            self.append(path3!)
        default:
            self.append(path)
        }
    }
}
