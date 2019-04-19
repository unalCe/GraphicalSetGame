//
//  Card.swift
//  SetGame
//
//  Created by Unal Celik on 20.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import Foundation

struct Card: Equatable {
    // MARK: - Variables
    private var identifier: Int
    private static var identifierCount = 0
    
    var isMatched: Bool?
    var isSelected = false
    var shape: Shape
    var color: Color
    var filling: Filling
    var number: Number
    
    // MARK: - Functions
    /// Returns true if both card instance's identifiers equal. False otherwise.
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    /// Returns unique identifier for each card created.
    static func getUniqueIdentifier() -> Int {
        identifierCount += 1
        return identifierCount
    }
    
    /// Initializes the card according to shape, color, filling and number properties.
    init(shape: Shape, color: Color, filling: Filling, number: Number) {
        self.shape = shape; self.color = color; self.number = number; self.filling = filling
        identifier = Card.getUniqueIdentifier()
    }
}
// MARK: -
extension Card {
    enum Shape: CaseIterable {
        case squiggle
        case oval
        case diamond
    }
    
    enum Filling: CaseIterable {
        case filled
        case striped
        case outlined
    }
    
    enum Color: String, CaseIterable {
        case red
        case purple
        case green
    }
    
    enum Number: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
}

