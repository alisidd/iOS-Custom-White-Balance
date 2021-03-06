//
//  ImageViewController.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/5/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var holderView: UIView!
    var imageSelected = UIImage()
    @IBOutlet weak var toolbar: UIToolbar!
    var resultsShowing = false
    
    var markers = [Marker]()
    var idealMarker: Marker?
    
    @IBOutlet weak var changeToRedButton: UIButton!
    @IBOutlet weak var changeToBlueButton: UIButton!
    
    
    @IBOutlet weak var averageIntensity: UILabel!
    
    @IBOutlet weak var firstpHValue: UILabel!
    @IBOutlet weak var secondpHValue: UILabel!
    @IBOutlet weak var thirdpHValue: UILabel!
    @IBOutlet weak var fourthpHValue: UILabel!
    
    @IBOutlet weak var firstSensorView: UIView!
    @IBOutlet weak var secondSensorView: UIView!
    @IBOutlet weak var thirdSensorView: UIView!
    @IBOutlet weak var fourthSensorView: UIView!
    
    @IBOutlet weak var firstSensorWarningIndicator: UIImageView!
    @IBOutlet weak var secondSensorWarningIndicator: UIImageView!
    @IBOutlet weak var thirdSensorWarningIndicator: UIImageView!
    @IBOutlet weak var fourthSensorWarningIndicator: UIImageView!
    
    @IBOutlet weak var warningMessage: UILabel!
    var totalWarnings = 0
    
    var function = pHFunction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderView.isHidden = true
        setImage()
        setScrollView()
        setHolderView()
        
        updateZoom(forSize: view.bounds.size)
        setGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customizeNavigationBar()
    }
    
    func setScrollView() {
        scrollView.delegate = self
        scrollView.contentSize = imageView.image!.size
    }
    
    func setHolderView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = holderView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        holderView.insertSubview(blurEffectView, at: 0)
        
        holderView.layer.cornerRadius = 10
        holderView.clipsToBounds = true
    }
    
    func setImage() {
        imageView.image = imageSelected
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
    }
    
    func customizeNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = UIColor(red: 183/255, green: 127/255, blue: 140/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Results", style: .done, target: self, action: #selector(getStats))
        self.navigationItem.rightBarButtonItem?.title = "Results"
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func makeMarker(forColor color: UIColor, withType type: String, atPos pos: CGPoint) {
        let customMarker = Marker()
        customMarker.frame = CGRect(x: pos.x - 100, y: pos.y - 100, width: 200, height: 200)
        customMarker.color = color
        addMarker(forMarker: customMarker, withType: type)
        
        imageView.addSubview(customMarker)
    }
    
    func addMarker(forMarker marker: Marker, withType type: String) {
        if marker.color == .white {
            idealMarker = marker
        } else {
            markers.append(marker)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func updateZoom(forSize size: CGSize) {
        scrollView.minimumZoomScale = 0.1
        scrollView.zoomScale = 0.25
    }
    
    func setGestureRecognizers() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(detectPress(_:)))
        
        imageView.gestureRecognizers = [longPressRecognizer]
    }
    
    func detectPress(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            if markers.count == 4 && idealMarker == nil {
                self.makeMarker(forColor: .white, withType: "red", atPos: recognizer.location(in: imageView))
                navigationItem.title = ""
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else if markers.count < 4 {
                self.makeMarker(forColor: .red, withType: "red", atPos: recognizer.location(in: imageView))
                if markers.count == 4 {
                    navigationItem.title = "Choose Background"
                }
            }
        }
        
    }
    
    // MARK: - Navigation
    
    func getStats() {
        if !resultsShowing {
            UIView.animate(withDuration: 0.5) {
                print(UIScreen.main.bounds.height)
                self.holderView.frame.origin.y = UIScreen.main.bounds.height - 10 - self.holderView.frame.height
                self.holderView.isHidden = false
                
                self.resultsShowing = true
                self.setResults(forType: "red")
            }
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            UIView.animate(withDuration: 0.5) {
                self.holderView.frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height
                
                self.resultsShowing = false
            }
            navigationItem.rightBarButtonItem?.title = "Results"
        }
    }
    
    func setResults(forType type: String) {
        var colorIntensities = [(red: CGFloat, green: CGFloat, blue: CGFloat)]()
        reorderMarkers()
        
        for marker in markers {
            let colorsFound = marker.colorOfCenter()
            colorIntensities.append(red: colorsFound.red, green: colorsFound.green, blue: colorsFound.blue)
        }
        
        if type == "red" {
            if let fetchedFunction = UserDefaults.standard.string(forKey: "redpHFunction") {
                setValues(forFunction: fetchedFunction, withColorIntensities: colorIntensities, forType: type)
            }
        } else {
            if let fetchedFunction = UserDefaults.standard.string(forKey: "bluepHFunction") {
                setValues(forFunction: fetchedFunction, withColorIntensities: colorIntensities, forType: type)
            }
        }
    }
    
    func setValues(forFunction fetchedFunction: String, withColorIntensities colorIntensities: [(red: CGFloat, green: CGFloat, blue: CGFloat)], forType type: String) {
        totalWarnings = 0
        
        function.setResult(forColors: [colorIntensities[0]], withIdeal: idealMarker!.colorOfCenter(), forType: type, forFunction: fetchedFunction)
        
        firstpHValue.text = String(describing: function.pH)
        setWarningIndicator(withValue: function.pH, forSensorNum: 1)
        firstSensorView.backgroundColor = UIColor(red: colorIntensities[0].red / 255, green: colorIntensities[0].green / 255, blue: colorIntensities[0].blue / 255, alpha: 1)
        
        function.setResult(forColors: [colorIntensities[1]], withIdeal: idealMarker!.colorOfCenter(), forType: type, forFunction: fetchedFunction)
        
        secondpHValue.text = String(describing: function.pH)
        setWarningIndicator(withValue: function.pH, forSensorNum: 2)
        secondSensorView.backgroundColor = UIColor(red: colorIntensities[1].red / 255, green: colorIntensities[1].green / 255, blue: colorIntensities[1].blue / 255, alpha: 1)
        
        function.setResult(forColors: [colorIntensities[2]], withIdeal: idealMarker!.colorOfCenter(), forType: type, forFunction: fetchedFunction)
        
        thirdpHValue.text = String(describing: function.pH)
        setWarningIndicator(withValue: function.pH, forSensorNum: 3)
        thirdSensorView.backgroundColor = UIColor(red: colorIntensities[2].red / 255, green: colorIntensities[2].green / 255, blue: colorIntensities[2].blue / 255, alpha: 1)
        
        function.setResult(forColors: [colorIntensities[3]], withIdeal: idealMarker!.colorOfCenter(), forType: type, forFunction: fetchedFunction)
        
        fourthpHValue.text = String(describing: function.pH)
        setWarningIndicator(withValue: function.pH, forSensorNum: 4)
        fourthSensorView.backgroundColor = UIColor(red: colorIntensities[3].red / 255, green: colorIntensities[3].green / 255, blue: colorIntensities[3].blue / 255, alpha: 1)
        
        function.setResult(forColors: colorIntensities, withIdeal: idealMarker!.colorOfCenter(), forType: type, forFunction: fetchedFunction)
        
        averageIntensity.text = String(describing: function.resultColor)
        if totalWarnings > 0 {
            warningMessage.text = "There's a possibility of infection, see your doctor immediately"
        } else {
            warningMessage.text = "No infections detected"
        }
    }
    
    func setWarningIndicator(withValue value: Double, forSensorNum sensor: Int) {
        // FIXME: This if condition will fail a lot of times if given incorrect input
        if value < Double(UserDefaults.standard.string(forKey: "maxpH")!)! && value > Double(UserDefaults.standard.string(forKey: "minpH")!)! {
            switch sensor {
            case 1: firstSensorWarningIndicator.image  = #imageLiteral(resourceName: "tick-2")
            case 2: secondSensorWarningIndicator.image = #imageLiteral(resourceName: "tick-2")
            case 3: thirdSensorWarningIndicator.image  = #imageLiteral(resourceName: "tick-2")
            case 4: fourthSensorWarningIndicator.image = #imageLiteral(resourceName: "tick-2")
            default: break
            }
            
        } else {
            totalWarnings += 1
            switch sensor {
            case 1: firstSensorWarningIndicator.image  = #imageLiteral(resourceName: "warning-1")
            case 2: secondSensorWarningIndicator.image = #imageLiteral(resourceName: "warning-1")
            case 3: thirdSensorWarningIndicator.image  = #imageLiteral(resourceName: "warning-1")
            case 4: fourthSensorWarningIndicator.image = #imageLiteral(resourceName: "warning-1")
            default: break
            }
        }
    }
    
    @IBAction func setRedValues(_ sender: UIButton) {
        self.setResults(forType: "red")
        UIView.animate(withDuration: 0.5) {
            self.changeToRedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
            self.changeToBlueButton.titleLabel?.font = UIFont.systemFont(ofSize: 21.0)
        }
    }
    
    @IBAction func setBlueValues(_ sender: UIButton) {
        self.setResults(forType: "blue")
        UIView.animate(withDuration: 0.5) {
            self.changeToBlueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
            self.changeToRedButton.titleLabel?.font = UIFont.systemFont(ofSize: 21.0)
        }
        
    }
    
    func reorderMarkers() {
        print("Reordering")
        var organizedMarkers = [markers[0]]
        
        for marker in markers {
            if marker != markers[0] {
                for i in 0..<organizedMarkers.count {
                    if marker.getCenter().y < organizedMarkers[i].getCenter().y {
                        organizedMarkers.insert(marker, at: i)
                        break
                    } else if i == organizedMarkers.count - 1 {
                        organizedMarkers.append(marker)
                    }
                }
            }
        }
        
        var topTwoMarkers = organizedMarkers[0...1]
        var bottomTwoMarkers = organizedMarkers[2...3]
        
        if topTwoMarkers[0].getCenter().x < topTwoMarkers[1].getCenter().x {
            markers = [topTwoMarkers[0], topTwoMarkers[1]]
        } else {
            markers = [topTwoMarkers[1], topTwoMarkers[0]]
        }
        
        if bottomTwoMarkers[2].getCenter().x < bottomTwoMarkers[3].getCenter().x {
            markers.append(contentsOf: [bottomTwoMarkers[2], bottomTwoMarkers[3]])
        } else {
            markers.append(contentsOf: [bottomTwoMarkers[3], bottomTwoMarkers[2]])
        }
    }
    
    func alertUser(withMessage customMessage: String) {
        let alert = UIAlertController(title: "Incomplete Sensors", message: customMessage, preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 183/255, green: 127/255, blue: 140/255, alpha: 1)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
