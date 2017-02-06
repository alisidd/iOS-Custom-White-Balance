//
//  SelectButton.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/5/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class SelectButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 168/255, green: 25/255, blue: 1/255, alpha: 1).cgColor
        layer.cornerRadius = 10
    }
}
