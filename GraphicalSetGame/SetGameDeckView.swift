//
//  SetGameDeckView.swift
//  GraphicalSetGame
//
//  Created by Unal Celik on 26.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import UIKit

class SetGameDeckView: UIView {
    
    var cards: [Card]? {
        didSet {
            
        }
    }
    
    var cellCount: Int { get { return cards?.count ?? 0 } }
    
    var cellSpace: CGFloat { get { return 48 / (CGFloat(cellCount)) } }
    
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
        removeAllSubviews()
        
        for index in 0..<cellCount {
            let viewTest = UIView(frame: grid?[index]?.insetBy(dx: cellSpace, dy: cellSpace) ?? .zero)
            print(viewTest.frame)
            viewTest.backgroundColor = .blue
            addSubview(viewTest)
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
