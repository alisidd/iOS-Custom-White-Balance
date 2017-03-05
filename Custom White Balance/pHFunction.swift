//
//  ColorBalanceFunction.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/6/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import Foundation
import UIKit

class pHFunction {
    var averageRedColor = CGFloat()
    var averageBlueColor = CGFloat()
    var resultColor = CGFloat()
    var pH = Double()
    
    func evaluateFunction(forFunction function: String) {
        let function = function.replacingOccurrences(of: "x", with: "resultColor", options: .literal, range: nil)
        
        let color = ["resultColor": resultColor]
                
        pH = NSExpression(format: function).expressionValue(with: color, context: nil) as! Double
    }
    
    func setResult(forColors colors: [(red: CGFloat, blue: CGFloat)], withIdeal idealColor: (colorValue: CGFloat, type: String), forFunction function: String) {
        var sumOfRedColors: CGFloat = 0
        var sumOfBlueColors: CGFloat = 0
        
        // Get the sum and average of all the selected colors
        for color in colors {
            sumOfRedColors += color.red
        }
        
        for color in colors {
            sumOfBlueColors += color.blue
        }
        
        averageRedColor = sumOfRedColors / CGFloat(colors.count)
        averageBlueColor = sumOfBlueColors / CGFloat(colors.count)
        print(colors.count)
        
        if idealColor.type == "red" {
            resultColor = idealColor.colorValue - averageRedColor
            
            evaluateFunction(forFunction: function)
        } else if idealColor.type == "blue" {
            resultColor = idealColor.colorValue - averageBlueColor
            
            evaluateFunction(forFunction: function)
        }
        
    }
}
