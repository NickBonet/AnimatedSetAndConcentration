//
//  Card.swift
//  Concentration
//
//  Created by Nicholas Bonet on 9/3/20.
//  Copyright © 2020 Nick Bonet. All rights reserved.
//

import Foundation

struct Card : Equatable {
    public var identifier: Int
    public var wasSeen = false
    public var isSelected = false
    
    public init(_ identifier: Int) {
        self.identifier = identifier
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.isSelected == rhs.isSelected
    }
}
