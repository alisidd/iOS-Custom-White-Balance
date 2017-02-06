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
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.maxX / 2 + 45, y: bounds.maxY / 2 + 45), radius: 60, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true)
        
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
    
    // Function taken from http://stackoverflow.com/questions/3284185/get-pixel-color-of-uiimage
    func colorOfCenter() -> CGFloat {
        let imageView = superview as! UIImageView
        let image = imageView.image!
        
        let pixelData = image.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(image.size.width) * Int(center.y)) + Int(center.x)) * 4

        let red   = CGFloat(data[pixelInfo + 0])
        let green = CGFloat(data[pixelInfo + 1])
        let blue  = CGFloat(data[pixelInfo + 2])
        
        switch color {
        case UIColor.red:   return red
        case UIColor.blue:  return blue
        default:            return green //#todo fix this
        }
    }

}
