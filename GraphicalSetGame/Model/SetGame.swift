//
//  Set.swift
//  SetGame
//
//  Created by Unal Celik on 20.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import Foundation

class SetGame
{
    // MARK: - Variables
    private(set) var upperCardLimit = 81
    private(set) var standarCardCount = 12
    
    var score: Int
    lazy var succesScore = 10 - Int(0.1 * Double(gameRange))
    lazy var failScore = 3 + Int(0.1 * Double(gameRange))
    
    private(set) var deck = [Card]()
    private(set) var cardsOnTable: [Card]
    
    var gameRange: Int {
        didSet {
            if gameRange > upperCardLimit { gameRange = upperCardLimit }
            cardsOnTable += deck.getFirst(amountOf: gameRange - cardsOnTable.count)
        }
    }
    
    var didThreeCardSelected: Bool {
        return selectedCards.count == 3
    }
    
    private var selectedCards: [Card] {
        get {
            return cardsOnTable.filter() { $0.isSelected }
        }
    }
    
    // MARK: - Functions
    /**
     If the deck is not empty, replaces the card in the table for a given index. Otherwise the card will be deleted.
     - parameter index: Index of selected card on the table
     */
    private func bringNewCardIfDeckNotEmpty(forIndex index: Int) {
        if !deck.isEmpty {
            cardsOnTable[index] = deck.removeFirst()
        } else {
            // This card is now a member of matchedCardsThatWillBeRemoved
            cardsOnTable[index].isSelected = false
            cardsOnTable[index].isMatched = true
            gameRange -= 1
        }
    }
    
    /// Changes match cards with new ones from the deck, if the cards are not match then reset the selected cards to initial values.
     func changeMatchedCards() {
        for index in cardsOnTable.indices {
            if cardsOnTable[index].isMatched ?? false {
                bringNewCardIfDeckNotEmpty(forIndex: index)
            } else {
                cardsOnTable[index].isSelected = false; cardsOnTable[index].isMatched = nil
            }
        }
        removeMatchedCards()
    }
    
    /// Removes matched cards.
    private func removeMatchedCards() {
        cardsOnTable.removeAll(where: {$0.isMatched ?? false && !$0.isSelected })
    }
    
/**
     Selects the card and checks if it's set or not. Changes the score accordingly.
     - parameter index: Index of selected card on the table
*/
    func selectCard(at index: Int) {
        /// Return from function if the deck is empty.
        if didThreeCardSelected { changeMatchedCards() }
        
        if !(cardsOnTable[index].isSelected) {
            cardsOnTable[index].isSelected = true
            
            if didThreeCardSelected {
                if checkIfMatch() {
                    score += succesScore
                    cardsOnTable.indices.forEach() { if cardsOnTable[$0].isSelected { cardsOnTable[$0].isMatched = true } }
                } else {
                    score -= failScore
                    cardsOnTable.indices.forEach() { if cardsOnTable[$0].isSelected { cardsOnTable[$0].isMatched = false } }
                }
            }
        } else {
            // deselect
            cardsOnTable[index].isSelected = false
            score -= 1
        }
    }
    
/**
     Returns true or false according to if all selected cards are set or not
     - returns: Bool - Set or not
 */
    private func checkIfMatch() -> Bool {
        var numbers = Set<Card.Number>()
        var shapes = Set<Card.Shape>()
        var colors = Set<Card.Color>()
        var fillings = Set<Card.Filling>()
        
        for card in selectedCards {
            numbers.insert(card.number); shapes.insert(card.shape); colors.insert(card.color); fillings.insert(card.filling)
        }
        // If the count is 1 then all of them are same. If it's 3 then all of them are unique.
        let isSet = numbers.count != 2 && shapes.count != 2 && colors.count != 2 && fillings.count != 2
        return isSet
    }
    
/// Shuffles cards on the table including the deck. If there are already matched cards, first removes them.
    func shuffleCards() {
        changeMatchedCards()
        
        deck += cardsOnTable
        deck.shuffle()
        cardsOnTable = deck.getFirst(amountOf: gameRange)
    }
    
/// Create the deck then shuffle. After that, fill up the table considering game range
    init() {
        deck = []
        gameRange = standarCardCount
        score = 0
        for number in Card.Number.allCases {
            for shape in Card.Shape.allCases {
                for color in Card.Color.allCases {
                    for filling in Card.Filling.allCases {
                        let card = Card(shape: shape, color: color, filling: filling, number: number)
                        deck += [card]
                    }
                }
            }
        }
        deck.shuffle()
        cardsOnTable = deck.getFirst(amountOf: gameRange)
    }
}
// MARK: -
extension Array where Element == Card {
    /// Returns given amount of elements from beginning of the array, and removes them.
    mutating func getFirst(amountOf: Int) -> [Element] {
        var returnCards = [Element]()
        if 0 < amountOf && amountOf <= self.count {
            for _ in 0..<amountOf {
                returnCards.append(self.removeFirst())
            }
            return returnCards
        }
        return []
    }
}

