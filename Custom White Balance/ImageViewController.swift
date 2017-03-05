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
    var idealMarker: (marker: Marker?, type: String)?
    
    @IBOutlet weak var averageIntensity: UILabel!

    @IBOutlet weak var firstpHValue: UILabel!
    @IBOutlet weak var secondpHValue: UILabel!
    @IBOutlet weak var thirdpHValue: UILabel!
    @IBOutlet weak var fourthpHValue: UILabel!
    
    @IBOutlet weak var firstSensorView: UIView!
    @IBOutlet weak var secondSensorView: UIView!
    @IBOutlet weak var thirdSensorView: UIView!
    @IBOutlet weak var fourthSensorView: UIView!
    
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
        print("Amount: \(holderView.subviews.count)")
        
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
            idealMarker = (marker, type)
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
                self.holderView.frame.origin.y = self.view.frame.origin.y + 194
                self.holderView.isHidden = false
                
                self.resultsShowing = true
                self.askForFunction()
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
    
    func setResults() {
        var colorIntensities = [(red: CGFloat, green: CGFloat, blue: CGFloat)]()
        reorderMarkers()
        
        for marker in markers {
            let colorsFound = marker.colorOfCenter()
            colorIntensities.append(red: colorsFound.red, green: colorsFound.green, blue: colorsFound.blue)
        }
        
        let fetchedFunction = UserDefaults.standard.string(forKey: "pHFunction")!
        
        setValues(forFunction: fetchedFunction, withColorIntensities: colorIntensities)
    }
    
    func setValues(forFunction fetchedFunction: String, withColorIntensities colorIntensities: [(red: CGFloat, green: CGFloat, blue: CGFloat)]) {
        function.setResult(forColors: [colorIntensities[0]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        firstpHValue.text = String(describing: function.pH)
        firstSensorView.backgroundColor = UIColor(red: colorIntensities[0].red / 255, green: colorIntensities[0].green / 255, blue: colorIntensities[0].blue / 255, alpha: 1)
        
        function.setResult(forColors: [colorIntensities[1]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        secondpHValue.text = String(describing: function.pH)
        secondSensorView.backgroundColor = UIColor(red: colorIntensities[1].red / 255, green: colorIntensities[1].green / 255, blue: colorIntensities[1].blue / 255, alpha: 1)
        
        function.setResult(forColors: [colorIntensities[2]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        thirdpHValue.text = String(describing: function.pH)
        thirdSensorView.backgroundColor = UIColor(red: colorIntensities[2].red / 255, green: colorIntensities[2].green / 255, blue: colorIntensities[2].blue / 255, alpha: 1)
        
        function.setResult(forColors: [colorIntensities[3]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        fourthpHValue.text = String(describing: function.pH)
        fourthSensorView.backgroundColor = UIColor(red: colorIntensities[3].red / 255, green: colorIntensities[3].green / 255, blue: colorIntensities[3].blue / 255, alpha: 1)
        
        function.setResult(forColors: colorIntensities, withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        averageIntensity.text = String(describing: function.resultColor)
    }
    
    func reorderMarkers() {
        var organizedMarkers = [markers[0]]
        
        for marker in markers {
            if marker != markers[0] {
                if marker.getCenter().y < organizedMarkers[0].getCenter().y {
                    organizedMarkers.insert(marker, at: 0)
                } else {
                    organizedMarkers.append(marker)
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
        print("Markers: \(markers)")
    }
    
    func askForFunction() {
        let alertController = UIAlertController(title: "pH Function", message: "Please enter the function:", preferredStyle: .alert)
        alertController.view.tintColor = UIColor(red: 183/255, green: 127/255, blue: 140/255, alpha: 1)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let fetchedFunction = alertController.textFields?[0].text, !fetchedFunction.isEmpty {
                UserDefaults.standard.set(fetchedFunction, forKey: "pHFunction")
                UserDefaults.standard.synchronize()
                self.setResults()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.getStats()
        }
        
        alertController.addTextField { (textField) in
            if let functionAlreadySet = UserDefaults.standard.string(forKey: "pHFunction") {
                textField.text = functionAlreadySet
            }
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertUser(withMessage customMessage: String) {
        let alert = UIAlertController(title: "Incomplete Sensors", message: customMessage, preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 183/255, green: 127/255, blue: 140/255, alpha: 1)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
