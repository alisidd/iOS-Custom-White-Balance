//
//  Marker.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/5/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class Marker: UIView, UIGestureRecognizerDelegate {
    
    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 60, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true)
        
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

}
