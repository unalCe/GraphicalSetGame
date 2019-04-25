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
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapSetCard(byHandlingGestureRecognizedBy:)))
            setGameDeckView.addGestureRecognizer(tap)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(with:)))
            swipeDown.direction = .down
            setGameDeckView.addGestureRecognizer(swipeDown)
            
            let rotateGest = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(with:)))
            setGameDeckView.addGestureRecognizer(rotateGest)
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
    
    // MARK: - Variables
    var game = SetGame()
    var selectedSetCardViewNo: Int?
    let defaultBorderWidth: CGFloat = 0.5
    let defaultBorderColor = UIColor.darkGray.cgColor
    let selectedBorderWidth: CGFloat = 3
    var selectedBorderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setGameDeckView.isUserInteractionEnabled = true
        
        updateViews()
    }
    
    // MARK: - Functions
    /// Update the cards on the table
    private func updateViews() {
        scoreLabel.text = "Score: \(game.score)"
        dealThreeMoreCardsButton.isEnabled = game.didThreeCardSelected || (game.gameRange < game.upperCardLimit && game.deck.count > 2)
        
        setGameDeckView.cards = game.cardsOnTable
        setGameDeckView.setNeedsLayout()
    }
    
    @objc func tapSetCard(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            guard let target = setGameDeckView.hitTest(recognizer.location(in: setGameDeckView), with: nil) as? SetCardView else { return }
            
            if let cardNo = setGameDeckView.subviews.index(of: target) {
                game.selectCard(at: cardNo)
                updateViews()
            }
        default: break
        }
    }
    
    @objc func dealThreeMoreCards(with swipeGesture: UISwipeGestureRecognizer) {
        switch swipeGesture.state {
        case .ended:
            dealThreeMoreCardsButton.sendActions(for: .touchUpInside)
        default: break
        }
    }
    
    @objc func shuffleCards(with rotationGesture: UIRotationGestureRecognizer) {
        switch rotationGesture.state {
        case .ended:
            game.shuffleCards()
            updateViews()
        default: break
        }
    }
}
