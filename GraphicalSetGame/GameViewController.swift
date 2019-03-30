//
//  ViewController.swift
//  SetGame
//
//  Created by Unal Celik on 20.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var setGameDeckView: SetGameDeckView! {
        didSet {
            setGameDeckView.cards = game.cardsOnTable
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton!
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton) {
        // Works nice. Looks meh.
        if game.didThreeCardSelected {
            game.changeMatchedCards()
        } else {
            game.gameRange += 3
        }
        updateViews()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        game = SetGame()
        updateViews()
    }
    
//    @IBAction func chooseCard(_ sender: UIButton) {
//        if let cardNo = cardCollection.index(of: sender) {
//            game.selectCard(at: cardNo)
//            initializeDeckView()
//            updateViews()
//        } else {
//            print("There is no such a card on the table.")
//        }
//    }
    
    // MARK: - Variables
    var game = SetGame()
    let defaultBorderWidth: CGFloat = 0.5
    let defaultBorderColor = UIColor.darkGray.cgColor
    let selectedBorderWidth: CGFloat = 3
    var selectedBorderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Functions
    /// Update the cards on the table
    private func updateViews() {
        scoreLabel.text = "Score: \(game.score)"
        dealThreeMoreCardsButton.isEnabled = game.didThreeCardSelected || (game.gameRange < game.upperCardLimit && game.deck.count > 2)
        
        setGameDeckView.cards = game.cardsOnTable
    }

}
