//
//  ColorBalanceFunction.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/6/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import Foundation
import UIKit

class ColorBalanceFunction {
    var averageRedColor = CGFloat()
    var averageBlueColor = CGFloat()
    var result = CGFloat()
    
    func setResult(forColors colors: [(red: CGFloat, blue: CGFloat)], withIdeal idealColor: (colorValue: CGFloat, type: String)) {
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
            result = idealColor.colorValue - averageRedColor
        } else if idealColor.type == "blue" {
            result = idealColor.colorValue - averageBlueColor
        }
    }
}
