//
//  Marker.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/5/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class Marker: UIView, UIGestureRecognizerDelegate {
    
    private let shapeLayer = CAShapeLayer()
    var color = UIColor.white {
        didSet {
            setColor(forColor: color)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: center.x + 100, y: center.y + 100), radius: 120, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true)
        
        circlePath.move(to: CGPoint(x: circlePath.bounds.midX, y: circlePath.bounds.minY))
        circlePath.addLine(to: CGPoint(x: circlePath.bounds.midX, y: circlePath.bounds.maxY))
        
        circlePath.move(to: CGPoint(x: circlePath.bounds.minX, y: circlePath.bounds.midY))
        circlePath.addLine(to: CGPoint(x: circlePath.bounds.maxX, y: circlePath.bounds.midY))
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        
        layer.addSublayer(shapeLayer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan(_:)))
        
        panRecognizer.delegate = self
        gestureRecognizers = [panRecognizer]
    }
    
    func detectPan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: superview!)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: superview!)
    }
    
    func setColor(forColor color: UIColor) {
        shapeLayer.strokeColor = color.cgColor
    }
    
    func getCenter() -> CGPoint {
        return center
    }
    
    func colorOfCenter() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let imageView = superview as! UIImageView
        
        var pixel : [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: UnsafeMutablePointer(mutating: pixel), width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -(center.x + 1), y: -(center.y + 1))
        imageView.layer.render(in: context!)
        
        return (red: CGFloat(pixel[0]), green: CGFloat(pixel[1]), blue: CGFloat(pixel[2]))
    }

}


