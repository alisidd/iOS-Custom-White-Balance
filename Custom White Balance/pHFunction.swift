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
        
        if idealColor.type == "red" {
            resultColor = idealColor.colorValue - averageRedColor
            
            evaluateFunction(forFunction: function)
            //pH = -1.61*pow(10, -5)*pow(resultColor, 3) + 5.23*pow(10, -3)*pow(resultColor, 2) - 5.67*pow(10, -1) * resultColor + 28.7
        } else if idealColor.type == "blue" {
            resultColor = idealColor.colorValue - averageBlueColor
            
            evaluateFunction(forFunction: function)
            //pH = -1.12*pow(10, -4)*pow(resultColor, 3) + 2.7*pow(10, -2)*pow(resultColor, 2) - 2.20*resultColor + 68.2
        }
        
    }
}
