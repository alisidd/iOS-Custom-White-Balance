//
//  StatsViewController.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/6/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet weak var redValue: UILabel!
    @IBOutlet weak var blueValue: UILabel!
    @IBOutlet weak var result: UILabel!
    
    var colors = [(red: CGFloat, blue: CGFloat)]()
    var idealColorMarker = (marker: Marker(), type: String())
    var function = pHFunction()

    override func viewDidLoad() {
        super.viewDidLoad()

        if idealColorMarker.type == "red" {
            //function.setResult(forColors: colors, withIdeal: (idealColorMarker.marker.colorOfCenter().red, idealColorMarker.type))
        } else {
            //function.setResult(forColors: colors, withIdeal: (idealColorMarker.marker.colorOfCenter().blue, idealColorMarker.type))
        }
        
        redValue.text = String(describing: function.averageRedColor)
        blueValue.text = String(describing: function.averageBlueColor)
        //result.text = String(describing: function.result)
        
    }

}
