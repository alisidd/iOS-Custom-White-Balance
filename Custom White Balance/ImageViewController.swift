//
//  ImageViewController.swift
//  Custom White Balance
//
//  Created by Ali Siddiqui on 2/5/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageSelected = UIImage()
    @IBOutlet weak var toolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()

        setImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customizeNavigationBar()
        customizeToolbar()
    }
    
    func setImage() {
        imageView.image = imageSelected
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.darkGray
    }
    
    func customizeNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 160/255, blue: 161/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func customizeToolbar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items?.append(space)
    }

    @IBAction func addMarker(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 0, green: 160/255, blue: 161/255, alpha: 1)
        
        let addRedMarker = UIAlertAction(title: "Add Red Marker", style: .default) { action in
            print("WOW")
        }
        
        let addBlueMarker = UIAlertAction(title: "Add Blue Marker", style: .default) { action in
            print("WOW")
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("WOW")
        }
        
        alert.addAction(addRedMarker)
        alert.addAction(addBlueMarker)
        alert.addAction(cancelActionButton)
        
        present(alert, animated: true)
    }
    
    @IBAction func addIdealMarker(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(red: 0, green: 160/255, blue: 161/255, alpha: 1)
        
        let addIdealRedMarker = UIAlertAction(title: "Add Ideal Red Marker", style: .default) { action in
            print("WOW")
        }
        
        let addIdealBlueMarker = UIAlertAction(title: "Add Ideal Blue Marker", style: .default) { action in
            print("WOW")
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("WOW")
        }
        
        alert.addAction(addIdealRedMarker)
        alert.addAction(addIdealBlueMarker)
        alert.addAction(cancelActionButton)
        
        present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
