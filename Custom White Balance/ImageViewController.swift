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
    var idealMarker = Marker()

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
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.darkGray
        imageView.isUserInteractionEnabled = true
    }
    
    func customizeNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 160/255, blue: 161/255, alpha: 1)
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
            self.makeMarker(forColor: .red)
        }
        
        let addBlueMarker = UIAlertAction(title: "Add Blue Marker", style: .default) { action in
            self.makeMarker(forColor: .blue)
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
            self.makeMarker(forColor: .white)
        }
        
        let addIdealBlueMarker = UIAlertAction(title: "Add Ideal Blue Marker", style: .default) { action in
            self.makeMarker(forColor: .white)
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addIdealRedMarker)
        alert.addAction(addIdealBlueMarker)
        alert.addAction(cancelActionButton)
        
        present(alert, animated: true)
    }
    
    func makeMarker(forColor color: UIColor) {
        let customMarker = Marker()
        customMarker.frame = CGRect(x: view.center.x, y: view.center.y, width: 90, height: 90)
        customMarker.color = color
        addMarker(forMarker: customMarker)
        
        imageView.addSubview(customMarker) // #todo put this in the didSet
    }
    
    func addMarker(forMarker marker: Marker) {
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
        scrollView.minimumZoomScale = 0.25
        scrollView.zoomScale = 3
    }
    
    // MARK: - Navigation
     
    func getStats() {
        for marker in markers {
            print(marker.colorOfCenter())
        }
        performSegue(withIdentifier: "Show Stats", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Stats" {
            if let destinationVC = segue.destination as? StatsViewController {
                
            }
        }
    }
}
