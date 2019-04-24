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
    var cellSpace: CGFloat { get { return CGFloat(2 + (32 / cellCount)) } }     // 32 looked good. Check if it's ok for other screen sizes.
    
    private var grid: Grid?
    private func customiseGrid() {
        grid = Grid(layout: Grid.Layout.aspectRatio(8/5))
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
        
        updateSubviews()
    }
    
    private func updateSubviews() {
        removeAllSubviews()
        
        for index in 0..<cellCount {
            let cardView = SetCardView(frame: grid?[index]?.insetBy(dx: cellSpace, dy: cellSpace) ?? .zero, with: cards[index])
            addSubview(cardView)
        }
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
