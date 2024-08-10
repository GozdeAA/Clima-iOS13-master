//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var searchController: UITextField!
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!

    @IBAction func searchPressed(_ sender: Any) {
        print("oy")
        searchController.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self // to access textfielddelegate
    }

    // cannot access this method withot uitextfielddelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text ?? "")
        searchController.endEditing(true) // to close the keyboard
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        searchController.text?.removeAll()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        } else {
            return true
        }
    }
}
