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
    @IBOutlet weak var statsView: UIView!
    var imageSelected = UIImage()
    @IBOutlet weak var toolbar: UIToolbar!
    var resultsShowing = false
    
    var markers = [Marker]()
    var idealMarker: (marker: Marker?, type: String)?
    
    @IBOutlet weak var firstpHValue: UILabel!
    @IBOutlet weak var secondpHValue: UILabel!
    @IBOutlet weak var thirdpHValue: UILabel!
    @IBOutlet weak var fourthpHValue: UILabel!
    @IBOutlet weak var averageIntensity: UILabel!


    var function = pHFunction()

    override func viewDidLoad() {
        super.viewDidLoad()
        statsView.isHidden = true
        setImage()
        setScrollView()
        setStatsView()
        
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
    
    func setStatsView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = statsView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        statsView.insertSubview(blurEffectView, at: 0)
        
        statsView.layer.cornerRadius = 10
        statsView.clipsToBounds = true
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
        if idealMarker == nil {
            alertUser(withMessage: "You need to add a background marker")
        } else if markers.count != 4 {
            alertUser(withMessage: "You need to add \(4 - markers.count) more marker\(markers.count < 3 ? "s" : "")")
        } else if !resultsShowing {
            
            UIView.animate(withDuration: 0.5) {
                self.statsView.frame.origin.y = self.view.frame.origin.y + 194
                self.statsView.isHidden = false
                
                self.resultsShowing = true
                self.askForFunction()
            }
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            UIView.animate(withDuration: 0.5) {
                self.statsView.frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height
                
                self.resultsShowing = false
            }
            navigationItem.rightBarButtonItem?.title = "Results"
        }
    }
    
    func setResults() {
        var colorIntensities = [(red: CGFloat, blue: CGFloat)]()
        
        for marker in markers {
            let colorsFound = marker.colorOfCenter()
            colorIntensities.append(red: colorsFound.red, blue: colorsFound.blue)
        }
        
        let fetchedFunction = UserDefaults.standard.string(forKey: "pHFunction")!
        
        function.setResult(forColors: [colorIntensities[0]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        firstpHValue.text = String(describing: function.pH)
        
        function.setResult(forColors: [colorIntensities[1]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        secondpHValue.text = String(describing: function.pH)
        
        function.setResult(forColors: [colorIntensities[2]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        thirdpHValue.text = String(describing: function.pH)
        
        function.setResult(forColors: [colorIntensities[3]], withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        fourthpHValue.text = String(describing: function.pH)
        
        function.setResult(forColors: colorIntensities, withIdeal: (idealMarker!.marker!.colorOfCenter().red, idealMarker!.type), forFunction: fetchedFunction)
        
        averageIntensity.text = String(describing: function.resultColor)
    }
    
    func askForFunction() {
        let alertController = UIAlertController(title: "pH Function", message: "Please enter the function:", preferredStyle: .alert)
        alertController.view.tintColor = UIColor(red: 1, green: 147/255, blue: 0, alpha: 1)
        
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let fetchedFunction = alertController.textFields?[0].text, !fetchedFunction.isEmpty {
                UserDefaults.standard.set(fetchedFunction, forKey: "pHFunction")
                UserDefaults.standard.synchronize()
                self.setResults()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
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
        let alert = UIAlertController(title: "Incomplete Markers", message: customMessage, preferredStyle: .alert)
        alert.view.tintColor = UIColor(red: 1, green: 147/255, blue: 0, alpha: 1)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
