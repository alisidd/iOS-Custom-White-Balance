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
    var averageColor = CGFloat()
    var result = CGFloat()
    
    func setResult(forColors colors: [CGFloat], withIdeal idealColor: CGFloat) {
        var sumOfColors: CGFloat = 0
        
        // Get the sum and average of all the selected colors
        for color in colors {
            sumOfColors += color
        }
        
        averageColor = sumOfColors / CGFloat(colors.count)
        
        result = idealColor - averageColor
    }
}
