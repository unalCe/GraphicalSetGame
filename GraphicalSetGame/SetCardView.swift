//
//  SetCardView.swift
//  GraphicalSetGame
//
//  Created by Unal Celik on 30.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    var shape: Card.Shape?
    var number: Card.Number?
    var color: Card.Color?
    var filling: Card.Filling?
    
    private func draw(shape: Card.Shape) {
        let drawingZone = bounds.inset(by: UIEdgeInsets(top: bounds.width / 4, left: bounds.width / 6, bottom: bounds.width / 4, right: bounds.width / 6))
        
        switch shape {
        case .diamond:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: drawingZone.midX, y: drawingZone.minY))
            path.addLine(to: CGPoint(x: drawingZone.maxX, y: drawingZone.midY))
            path.addLine(to: CGPoint(x: drawingZone.midX, y: drawingZone.maxY))
            path.addLine(to: CGPoint(x: drawingZone.minX, y: drawingZone.midY))
            path.close()
            UIColor.red.setStroke()
            path.lineWidth = 3
            path.stroke()
     //   case .oval:
     //       let ovalPath = UIBezierPath(ovalIn: <#T##CGRect#>)
        default:
            print("dx")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let background = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 5)
        UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).setFill()
        background.addClip()
        background.fill()
        
        draw(shape: shape ?? .diamond)
    }
}

//
//extension CGRect {
//    var drawingZone: CGRect {
//        return self.insetBy(dx: width / 4, dy: height / 4)
//    }
//}
