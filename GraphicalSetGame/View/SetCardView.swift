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

    
    private func getPath(for shape: Card.Shape, count: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let drawingZone = bounds.insetBy(dx: bounds.width * SizeProperties.safeZoneInsetRatio, dy: bounds.height * SizeProperties.safeZoneInsetRatio)
        let individualWidth = drawingZone.width * SizeProperties.individualShapeWidthRatioToDrawingZone
        
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
                // path.move(to: <#T##CGPoint#>)
                let halfTheWidth = singleShapeZone.width / 2
                
                // let upperLeftCurverStartPoint = CGPoint
                path.move(to: CGPoint(x: singleShapeZone.minX, y: halfTheWidth))
                path.addCurve(to: CGPoint(x: singleShapeZone.maxX, y: singleShapeZone.width * 0.8),
                              controlPoint1: CGPoint(x: halfTheWidth, y: 0),
                              controlPoint2: CGPoint(x: singleShapeZone.width * 1.2, y: singleShapeZone.width * 0.2))
                
            }
            
            singleShapeZone.origin.x += singleShapeZone.width + 2
            iterate += 1
        } while (iterate < count)
        
        path.addClip()
        return path
    }
    
    private func fill(path: UIBezierPath, with color: Card.Color, and filling: Card.Filling) {
        path.lineWidth = getOuterBorderWidth(for: path)
        UIColor.blue.setStroke()    // placeholder
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
            UIColor.blue.setFill() // ph
            path.fill()
        case .outlined: break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
        layer.cornerRadius = setCardCornerRadius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let background = UIBezierPath(roundedRect: bounds, cornerRadius: setCardCornerRadius)
        UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).setFill()
        background.addClip()
        background.fill()

        fill(path: getPath(for: shape ?? .squiggle, count: 1), with: .red, and: .outlined)
    }
}

extension SetCardView {
    private struct SizeProperties {
        static let safeZoneInsetRatio: CGFloat = 0.125
        static let setCardCornerRadiusRatio: CGFloat = 0.2
        static let outerBorderHeightRatioToPathWidth: CGFloat = 0.05
        static let stripeLineHeightRatioToPathWidth: CGFloat = 0.017
        static let strideFrequencyRatioToPathWidth: CGFloat = 0.14
        static let individualShapeWidthRatioToDrawingZone: CGFloat = 0.33
    }
    
    private func getEdgeInsetRect(forCount: Int) -> CGRect {
        return bounds.insetBy(dx: bounds.width * (SizeProperties.safeZoneInsetRatio * CGFloat(forCount)), dy: bounds.height * (SizeProperties.safeZoneInsetRatio * CGFloat(forCount)))
    }
    
    private var setCardCornerRadius: CGFloat {
        return bounds.height * SizeProperties.setCardCornerRadiusRatio
    }
    
    private func getOuterBorderWidth(for path: UIBezierPath) -> CGFloat {
        return path.bounds.height * SizeProperties.outerBorderHeightRatioToPathWidth
    }
    
    private func getStripeLineWidth(for path: UIBezierPath) -> CGFloat {
        return path.bounds.height * SizeProperties.stripeLineHeightRatioToPathWidth
    }
    
    private func getStrideFrequency(for path: UIBezierPath) -> CGFloat {
        if let number = number {
            return path.bounds.width * SizeProperties.strideFrequencyRatioToPathWidth / CGFloat(number.rawValue)
        } else {
            return path.bounds.width * SizeProperties.strideFrequencyRatioToPathWidth
        }
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

