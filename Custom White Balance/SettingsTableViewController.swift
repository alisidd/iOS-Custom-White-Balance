//
//  SettingsTableViewController.swift
//  iDerm
//
//  Created by Ali Siddiqui on 4/4/17.
//  Copyright © 2017 Ali Siddiqui. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var minpHField: UITextField!
    @IBOutlet weak var maxpHField: UITextField!
    
    var rows = [2, 1]

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        customizeFields()
        setDelegates()
        populateFields()
    }
    
    func customizeNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = UIColor(red: 183/255, green: 127/255, blue: 140/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func customizeFields() {
        minpHField.keyboardType = .decimalPad
        maxpHField.keyboardType = .decimalPad
    }
    
    func setDelegates() {
        minpHField.delegate = self
        maxpHField.delegate = self
    }
    
    func populateFields() {
        if let minpH = UserDefaults.standard.string(forKey: "minpH") {
            minpHField.text = minpH
        }
        
        if let maxpH = UserDefaults.standard.string(forKey: "maxpH") {
            maxpHField.text = maxpH
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == minpHField && !textField.text!.isEmpty {
            UserDefaults.standard.set(minpHField.text, forKey: "minpH")
        } else if !textField.text!.isEmpty {
            UserDefaults.standard.set(maxpHField.text, forKey: "maxpH")
        }
        
        return true
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return rows.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            alertpHFunction(forColor: "red")
        } else if indexPath.section == 0 && indexPath.row == 1 {
            alertpHFunction(forColor: "blue")
        }
        
    }
    
    func alertpHFunction(forColor color: String) {
        let alertController = UIAlertController(title: "pH Function", message: "Please enter the function for " + color + ": ", preferredStyle: .alert)
        alertController.view.tintColor = UIColor(red: 183/255, green: 127/255, blue: 140/255, alpha: 1)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let fetchedFunction = alertController.textFields?[0].text, !fetchedFunction.isEmpty {
                if color == "red" {
                    UserDefaults.standard.set(fetchedFunction, forKey: "redpHFunction")
                } else {
                    UserDefaults.standard.set(fetchedFunction, forKey: "bluepHFunction")
                }
                
                UserDefaults.standard.synchronize()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            if color == "red" {
                if let functionAlreadySet = UserDefaults.standard.string(forKey: "redpHFunction") {
                    textField.text = functionAlreadySet
                }
            } else {
                if let functionAlreadySet = UserDefaults.standard.string(forKey: "bluepHFunction") {
                    textField.text = functionAlreadySet
                }
            }
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
