//
//  SetCard.swift
//  SetGame
//
//  Created by Nicholas Bonet on 9/30/20.
//  Copyright © 2020 Nicholas Bonet. All rights reserved.
//

import Foundation

struct SetCard: Equatable {

    let color: Coloring
    let shade: Shade
    let shape: Shape
    var count: Int

    enum Coloring {
        case red
        case green
        case purple
        static let all = [red, purple, green]
    }

    enum Shade {
        case empty
        case filled
        case striped
        static let all = [empty, filled, striped]
    }

    enum Shape {
        case squiggle
        case diamond
        case oval
        static let all = [squiggle, diamond, oval]
    }
}
