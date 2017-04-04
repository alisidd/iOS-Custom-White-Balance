//
//  ColorBalanceFunction.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/6/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

//Function taken from: http://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

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
        pH = pH.roundTo(places: 1)
    }
    
    func setResult(forColors colors: [(red: CGFloat, green: CGFloat, blue: CGFloat)], withIdeal idealColor: (red: CGFloat, green: CGFloat, blue: CGFloat), forType type: String, forFunction function: String) {
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
        
        if type == "red" {
            resultColor = idealColor.red - averageRedColor
            
            evaluateFunction(forFunction: function)
        } else if type == "blue" {
            resultColor = idealColor.blue - averageBlueColor
            
            evaluateFunction(forFunction: function)
        }
        
    }
}
