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
        var path = UIBezierPath()
        let drawingZone = bounds.insetBy(dx: bounds.width * SizeProperties.safeZoneInsetRatio, dy: bounds.height * SizeProperties.safeZoneInsetRatio)
        let individualWidth = drawingZone.width * SizeProperties.individualShapeWidthRatioToDrawingZone
        let firstShapeRect = CGRect(x: drawingZone.midX - (individualWidth / 2) * CGFloat(count), y: drawingZone.minY, width: individualWidth, height: drawingZone.height)
        
        // for loop ile shapeRect ileri kaydır dene.
        switch shape {
        case .diamond:
            path.move(to: CGPoint(x: firstShapeRect.midX, y: firstShapeRect.minY))
            path.addLine(to: CGPoint(x: firstShapeRect.maxX, y: firstShapeRect.midY))
            path.addLine(to: CGPoint(x: firstShapeRect.midX, y: firstShapeRect.maxY))
            path.addLine(to: CGPoint(x: firstShapeRect.minX, y: firstShapeRect.midY))
            path.close()
        case .oval:
            path = UIBezierPath(roundedRect: firstShapeRect, cornerRadius: individualWidth / 2)
        case .squiggle:
            // path.move(to: <#T##CGPoint#>)
            print("draw")
        }
        
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

        fill(path: getPath(for: shape ?? .diamond, count: 1), with: .red, and: .striped)
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
        return path.bounds.width * SizeProperties.strideFrequencyRatioToPathWidth
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

