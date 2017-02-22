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
    var imageSelected = UIImage()
    @IBOutlet weak var toolbar: UIToolbar!
    
    var markers = [Marker]()
    var idealMarker: (marker: Marker?, type: String)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setImage()
        setScrollView()
        updateZoom(forSize: view.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customizeNavigationBar()
        customizeToolbar()
    }
    
    func setScrollView() {
        scrollView.delegate = self
        scrollView.contentSize = imageView.image!.size
    }
    
    func setImage() {
        imageView.image = imageSelected
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.darkGray
        imageView.isUserInteractionEnabled = true
    }
    
    func customizeNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 147/255, blue: 0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(getStats))
    }
    
    func customizeToolbar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items?.append(space)
    }

    @IBAction func addMarker(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 0, green: 160/255, blue: 161/255, alpha: 1)
        
        let addRedMarker = UIAlertAction(title: "Add Red Marker", style: .default) { action in
            self.makeMarker(forColor: .red, withType: "red")
        }
        
        let addBlueMarker = UIAlertAction(title: "Add Blue Marker", style: .default) { action in
            self.makeMarker(forColor: .blue, withType: "blue")
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addRedMarker)
        alert.addAction(addBlueMarker)
        alert.addAction(cancelActionButton)
        
        present(alert, animated: true)
    }
    
    @IBAction func addIdealMarker(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 0, green: 160/255, blue: 161/255, alpha: 1)
        
        let addIdealRedMarker = UIAlertAction(title: "Add Ideal Red Marker", style: .default) { action in
            self.makeMarker(forColor: .white, withType: "red")
        }
        
        let addIdealBlueMarker = UIAlertAction(title: "Add Ideal Blue Marker", style: .default) { action in
            self.makeMarker(forColor: .white, withType: "blue")
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addIdealRedMarker)
        alert.addAction(addIdealBlueMarker)
        alert.addAction(cancelActionButton)
        
        present(alert, animated: true)
    }
    
    func makeMarker(forColor color: UIColor, withType type: String) {
        let customMarker = Marker()
        customMarker.frame = CGRect(x: view.center.x, y: view.center.y, width: 90, height: 90)
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
        scrollView.minimumZoomScale = 0.25
        scrollView.zoomScale = 0.25
    }
    
    // MARK: - Navigation
     
    func getStats() {
        var colorIntensities = [(red: CGFloat, blue: CGFloat)]()
        
        for marker in markers {
            let colorsFound = marker.colorOfCenter()
            colorIntensities.append(red: colorsFound.red, blue: colorsFound.blue)
        }
        if idealMarker == nil {
            alertUser(withMessage: "You need to add an ideal marker")
        } else if markers.count == 0 {
            alertUser(withMessage: "You need to add a marker")
        } else {
            performSegue(withIdentifier: "Show Stats", sender: colorIntensities)
        }
    }
    
    func alertUser(withMessage customMessage: String) {
        let alert = UIAlertController(title: "Incomplete Markers", message: customMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Stats" {
            if let destinationVC = segue.destination as? StatsViewController {
                let colorIntensities = sender as! [(red: CGFloat, blue: CGFloat)]
                destinationVC.colors = colorIntensities
                if let unwrappedIdealMarker = idealMarker?.marker {
                    destinationVC.idealColorMarker = (marker: unwrappedIdealMarker, type: idealMarker!.type)
                }
            }
        }
    }
}
