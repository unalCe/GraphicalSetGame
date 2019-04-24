//
//  SetCardView.swift
//  GraphicalSetGame
//
//  Created by Unal Celik on 30.03.2019.
//  Copyright © 2019 unalCe. All rights reserved.
//

import UIKit

class SetCardView: UIView {

    var setCard: Card?
    
    /**
     Returns a UIBezierPath for a spesific card shape and count.
     - parameter shape: Shape of the drawing
     - parameter count: Count of the shape
     - returns: Resulting bezierpath
     */
    private func getPath(for shape: Card.Shape, count: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let drawingZone = bounds.insetBy(dx: bounds.width * SizeProperties.safeZoneInsetRatio, dy: bounds.height * SizeProperties.safeZoneInsetRatio)
        let individualWidth = drawingZone.width * SizeProperties.individualShapeWidthRatioToDrawingZone
        
        // Center the shapes according to count.
        var singleShapeZone = CGRect(x: drawingZone.midX - (individualWidth / 2) * CGFloat(count), y: drawingZone.minY, width: individualWidth, height: drawingZone.height)
        var iterate = 0
        
        repeat {
            switch shape {
            case .diamond:
                path.move(to: CGPoint(x: singleShapeZone.midX, y: singleShapeZone.minY))
                path.addLine(to: CGPoint(x: singleShapeZone.maxX, y: singleShapeZone.midY))
                path.addLine(to: CGPoint(x: singleShapeZone.midX, y: singleShapeZone.maxY))
                path.addLine(to: CGPoint(x: singleShapeZone.minX, y: singleShapeZone.midY))
                path.close()
            case .oval:
                let ovalRadius = singleShapeZone.width / 2
                let upperArcCenter = CGPoint(x: singleShapeZone.midX, y: singleShapeZone.minY + ovalRadius)
                let footerArcCenter = CGPoint(x: singleShapeZone.midX, y: singleShapeZone.maxY - ovalRadius)
                path.move(to: CGPoint(x: singleShapeZone.minX, y: singleShapeZone.minY + ovalRadius))
                path.addArc(withCenter: upperArcCenter, radius: ovalRadius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
                path.addLine(to: CGPoint(x: singleShapeZone.maxX, y: singleShapeZone.maxY - ovalRadius))
                path.addArc(withCenter: footerArcCenter, radius: ovalRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
                path.close()
            case .squiggle:
                let halfTheWidth = singleShapeZone.width / 2
                
                path.move(to: CGPoint(x: singleShapeZone.minX + halfTheWidth * 0.4, y: halfTheWidth * 1.1))
                path.addCurve(to: CGPoint(x: singleShapeZone.maxX - halfTheWidth * 0.3, y: halfTheWidth * 1.5),
                              controlPoint1: CGPoint(x: singleShapeZone.minX + halfTheWidth * 0.9, y: singleShapeZone.height * 0.1),
                              controlPoint2: CGPoint(x: singleShapeZone.minX + singleShapeZone.width * 1.2, y: halfTheWidth))
                path.addCurve(to: CGPoint(x: singleShapeZone.maxX - singleShapeZone.width * 0.1, y: singleShapeZone.maxY * 0.85),
                              controlPoint1: CGPoint(x: singleShapeZone.midX - halfTheWidth * 0.05, y: singleShapeZone.midY * 0.8),
                              controlPoint2: CGPoint(x: singleShapeZone.maxX, y: singleShapeZone.maxY * 0.7))
                path.addCurve(to: CGPoint(x: singleShapeZone.midX - halfTheWidth * 0.45, y: singleShapeZone.maxY * 0.75),
                              controlPoint1: CGPoint(x: singleShapeZone.maxX - singleShapeZone.width * 0.3, y: bounds.maxY),
                              controlPoint2: CGPoint(x: singleShapeZone.minX - singleShapeZone.width * 0.3, y: singleShapeZone.maxY))
                path.addCurve(to: CGPoint(x: singleShapeZone.minX + halfTheWidth * 0.4, y: halfTheWidth * 1.1),
                              controlPoint1: CGPoint(x: singleShapeZone.midX, y: singleShapeZone.maxY * 0.67),
                              controlPoint2: CGPoint(x: singleShapeZone.minX - singleShapeZone.width * 0.1, y: singleShapeZone.midY * 0.8))
            }
            
            singleShapeZone.origin.x += singleShapeZone.width + 2 // Two points of spacing between shapes.
            iterate += 1
        } while (iterate < count)
        
        path.addClip()
        return path
    }
    
    /**
     Fills the given path according to color and filling
     - parameter path: Bezierpath of the drawing
     - parameter color: Color of the drawing
     - parameter filling: Filling of the shape
     */
    private func fill(path: UIBezierPath, with color: Card.Color, and filling: Card.Filling) {
        guard let cardColor = setCard?.color.rawValue else { return }
        
        path.lineWidth = getShapeOuterBorderWidth(for: path)
        UIColor(named: cardColor)?.setStroke()
        path.stroke()
        
        switch filling {
        case .striped:
            for point in stride(from: path.bounds.minX, to: path.bounds.maxX, by: getStrideFrequency(for: path)) {
                path.move(to: CGPoint(x: point, y: bounds.minY))
                path.addLine(to: CGPoint(x: point, y: bounds.maxY))
            }
            path.lineWidth = getStripeLineWidth(for: path)
            path.stroke()
        case .filled:
            UIColor(named: cardColor)?.setFill()
            path.fill()
        case .outlined: break
        }
    }
    
    /**
     Custom initializer of the view. Adjusts the frame of the view and sets the card instance that will be drawed.
     - parameter frame: Frame of the view
     - parameter card: Card object that will be drawed.
     */
    init(frame: CGRect, with card: Card) {
        super.init(frame: frame)
        
        setCard = card
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
        layer.cornerRadius = setCardCornerRadius
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Draw card background
        let background = UIBezierPath(roundedRect: bounds, cornerRadius: setCardCornerRadius)
        UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).setFill()
        background.addClip()
        background.fill()
        
        if let card = setCard {
            // Draw card border
            (card.isSelected) ? selectedBorderColor.setStroke() : UIColor.darkGray.setStroke()
            background.lineWidth = getCardOuterBorderWidth(for: background, if: card.isSelected)
            background.stroke()
            
            fill(path: getPath(for: card.shape, count: card.number.rawValue), with: card.color, and: card.filling)
        } else {
            // TODO: Handle here
        }
    }
}

// MARK: -
extension SetCardView {
    private struct SizeProperties {
        static let defaultBorderWidthRatioToWidth: CGFloat = 0.02
        static let selectedBorderWidthRatioToWidth: CGFloat = 0.04
        static let safeZoneInsetRatio: CGFloat = 0.125
        static let setCardCornerRadiusRatio: CGFloat = 0.2
        static let outerBorderHeightRatioToPathWidth: CGFloat = 0.05
        static let stripeLineHeightRatioToPathWidth: CGFloat = 0.013
        static let strideFrequencyRatioToPathWidth: CGFloat = 0.14
        static let individualShapeWidthRatioToDrawingZone: CGFloat = 0.33
    }
    
    private func getEdgeInsetRect(forCount: Int) -> CGRect {
        return bounds.insetBy(dx: bounds.width * (SizeProperties.safeZoneInsetRatio * CGFloat(forCount)), dy: bounds.height * (SizeProperties.safeZoneInsetRatio * CGFloat(forCount)))
    }
    
    // TODO: Test if it's working correct.
    private var selectedBorderColor: UIColor {
        get {
            if let cardMatch = setCard?.isMatched {
                return cardMatch ? UIColor.green : UIColor.red }
            else {
                return UIColor.blue
            }
        }
    }
    
    private var setCardCornerRadius: CGFloat {
        return bounds.height * SizeProperties.setCardCornerRadiusRatio
    }
    
    private func getCardOuterBorderWidth(for path: UIBezierPath, if selected: Bool) -> CGFloat {
        return path.bounds.height * (selected ? SizeProperties.selectedBorderWidthRatioToWidth : SizeProperties.defaultBorderWidthRatioToWidth)
    }
    
    private func getShapeOuterBorderWidth(for path: UIBezierPath) -> CGFloat {
        return path.bounds.height * SizeProperties.outerBorderHeightRatioToPathWidth
    }
    
    private func getStripeLineWidth(for path: UIBezierPath) -> CGFloat {
        return path.bounds.height * SizeProperties.stripeLineHeightRatioToPathWidth
    }
    
    private func getStrideFrequency(for path: UIBezierPath) -> CGFloat {
        if let number = setCard?.number {
            return path.bounds.width * SizeProperties.strideFrequencyRatioToPathWidth / CGFloat(number.rawValue)
        } else {
            return path.bounds.width * SizeProperties.strideFrequencyRatioToPathWidth / 3
        }
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

