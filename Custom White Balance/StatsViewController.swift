//
//  StatsViewController.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/6/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    var colors = [CGFloat()]
    var idealColor = CGFloat()
    var function = ColorBalanceFunction()

    override func viewDidLoad() {
        super.viewDidLoad()

        function.setResult(forColors: colors, withIdeal: idealColor)
    }

}
