//
//  SetGameDeckView.swift
//  GraphicalSetGame
//
//  Created by Unal Celik on 26.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import UIKit

class SetGameDeckView: UIView {
    
    var cards = [Card]() { didSet { updateSubviews() } }
    var cellCount: Int { get { return cards.count } }
    var cellSpace: CGFloat { get { return CGFloat(2 + (32 / cellCount)) } }
    
    private var grid: Grid?
    private func customiseGrid() {
        grid = Grid(layout: Grid.Layout.aspectRatio(5/8))
        grid?.cellCount = cellCount
        grid?.frame = bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customiseGrid()
        
        let cardView = SetCardView(frame: CGRect(x: 50, y: 50, width: 120, height: 200))
        addSubview(cardView)
    }
    
    private func updateSubviews() {
        removeAllSubviews()
//        var cardBorderColor = UIColor.darkGray.cgColor

//        for index in 0..<cellCount {
//
//            if cards[index].isMatched ?? false { continue }
//
//            let cardView = UIView(frame: grid?[index]?.insetBy(dx: cellSpace, dy: cellSpace) ?? .zero)
//
//            if cards[index].isSelected { cardBorderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor }
//            cardView.layer.cornerRadius = cellSpace * 3
//            cardView.layer.borderColor = cardBorderColor
//            cardView.layer.borderWidth = cellSpace / 3
//            cardView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
//            addSubview(cardView)
//        }
    }
    
    func selectSetCard(forIndex index: Int) {
        cards[index].isSelected = true
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    // override func draw(_ rect: CGRect) {
    // Drawing code
    //}
    
    private func removeAllSubviews() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
}
