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

    // TODO: Iterate sayısı burada değil de color ve filling vereceğin metodun içinde loop etmek daha mantıklı gibi.
    // TODO:
    private func getPath(for shape: Card.Shape, count: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let drawingZone = bounds.insetBy(dx: bounds.width * SizeProperties.safeZoneInsetRatio, dy: bounds.height * SizeProperties.safeZoneInsetRatio)
        
        
        
        switch shape {
        case .diamond:
            path.move(to: CGPoint(x: drawingZone.midX, y: drawingZone.minY))
            path.addLine(to: CGPoint(x: drawingZone.maxX, y: drawingZone.midY))
            path.addLine(to: CGPoint(x: drawingZone.midX, y: drawingZone.maxY))
            path.addLine(to: CGPoint(x: drawingZone.minX, y: drawingZone.midY))
            path.close()
        case .oval:
            path.addArc(withCenter: CGPoint(x: drawingZone.midX, y: drawingZone.midY), radius: drawingZone.height / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            // Make a rounded rect.
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

        fill(path: getPath(for: shape ?? .diamond, count: 2), with: .red, and: .striped)
    }
}

extension SetCardView {
    private struct SizeProperties {
        static let safeZoneInsetRatio: CGFloat = 0.125
        static let setCardCornerRadiusRatio: CGFloat = 0.2
        static let outerBorderHeightRatioToPathWidth: CGFloat = 0.05
        static let stripeLineHeightRatioToPathWidth: CGFloat = 0.017
        static let strideFrequencyRatioToPathWidth: CGFloat = 0.1
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

